<?php
/**
 * Transactions API
 * Handles transaction creation, retrieval, and deletion
 */

require_once 'config.php';
require_once 'transaction_status_helper.php';

$method = $_SERVER['REQUEST_METHOD'];
$pdo = getDBConnection();

switch ($method) {
    case 'GET':
        // Get all transactions with pagination
        $limit = isset($_GET['limit']) ? intval($_GET['limit']) : 50;
        $offset = isset($_GET['offset']) ? intval($_GET['offset']) : 0;
        
        try {
            // Get total count
            $stmt = $pdo->query("SELECT COUNT(*) as total FROM uba_transactions");
            $total = $stmt->fetch()['total'];
            
            // Get transactions
            $stmt = $pdo->prepare("SELECT * FROM uba_transactions ORDER BY transaction_date DESC LIMIT ? OFFSET ?");
            $stmt->bindValue(1, $limit, PDO::PARAM_INT);
            $stmt->bindValue(2, $offset, PDO::PARAM_INT);
            $stmt->execute();
            $transactions = $stmt->fetchAll();
            
            sendResponse(true, [
                'transactions' => $transactions,
                'total' => intval($total),
                'limit' => $limit,
                'offset' => $offset
            ]);
        } catch (PDOException $e) {
            handleError('Failed to fetch transactions: ' . $e->getMessage(), 500);
        }
        break;
        
    case 'POST':
        // Create new transaction
        $input = getJsonInput();
        
        $required = ['reference', 'amount', 'beneficiary_name', 'beneficiary_bank', 'beneficiary_account', 'sender_account', 'sender_name'];
        foreach ($required as $field) {
            if (!isset($input[$field])) {
                handleError("Missing required field: $field");
            }
        }
        
        try {
            $pdo->beginTransaction();
            
            // Insert transaction
            $stmt = $pdo->prepare("
                INSERT INTO uba_transactions (
                    reference, amount, currency, beneficiary_name, beneficiary_bank, 
                    beneficiary_account, sender_account, sender_name, purpose, status, transaction_date
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
            ");
            
            $stmt->execute([
                $input['reference'],
                floatval($input['amount']),
                $input['currency'] ?? 'NGN',
                $input['beneficiary_name'],
                $input['beneficiary_bank'],
                $input['beneficiary_account'],
                $input['sender_account'],
                $input['sender_name'],
                $input['purpose'] ?? null,
                $input['status'] ?? 'SUCCESSFUL'
            ]);
            
            $transactionId = $pdo->lastInsertId();
            
            // Deduct balance from account (most recent account setting)
            $stmt = $pdo->query("SELECT id FROM uba_account_settings ORDER BY id DESC LIMIT 1");
            $accountRow = $stmt->fetch();
            $accountId = $accountRow['id'];
            
            $stmt = $pdo->prepare("UPDATE uba_account_settings SET balance = balance - ?, updated_at = NOW() WHERE id = ?");
            $stmt->execute([floatval($input['amount']), $accountId]);
            
            $pdo->commit();
            
            // Get created transaction
            $stmt = $pdo->prepare("SELECT * FROM uba_transactions WHERE id = ?");
            $stmt->execute([$transactionId]);
            $transaction = $stmt->fetch();

            try {
                require_once __DIR__ . '/mobile_fcm_helper.php';
                if ($transaction) {
                    mobileNotifyBeneficiaryCredit($pdo, $transaction, 'uba_transactions', 'uba');
                }
            } catch (Exception $e) {
                // Non-fatal: transfer already committed
            }
            
            sendResponse(true, $transaction, 'Transaction created successfully');
        } catch (PDOException $e) {
            $pdo->rollBack();
            handleError('Failed to create transaction: ' . $e->getMessage(), 500);
        }
        break;

    case 'PUT':
        validateAdminSession();
        $input = getJsonInput();
        $id = isset($input['id']) ? intval($input['id']) : (isset($_GET['id']) ? intval($_GET['id']) : 0);
        if (!$id) {
            handleError('Transaction ID is required');
        }
        if (!isset($input['status'])) {
            handleError('Status is required');
        }
        $newStatus = normalizeTransactionStatus($input['status']);
        if (!$newStatus) {
            handleError('Invalid status. Allowed: SUCCESSFUL, PENDING, FAILED, REVERSED');
        }

        try {
            $pdo->beginTransaction();

            $stmt = $pdo->prepare("SELECT id, amount, status FROM uba_transactions WHERE id = ?");
            $stmt->execute([$id]);
            $transaction = $stmt->fetch();
            if (!$transaction) {
                $pdo->rollBack();
                handleError('Transaction not found', 404);
            }

            $oldStatus = $transaction['status'] ?? 'SUCCESSFUL';
            if (normalizeTransactionStatus($oldStatus) === $newStatus) {
                $pdo->commit();
                $stmt = $pdo->prepare("SELECT * FROM uba_transactions WHERE id = ?");
                $stmt->execute([$id]);
                sendResponse(true, $stmt->fetch(), 'Status unchanged');
                break;
            }

            $stmt = $pdo->prepare("UPDATE uba_transactions SET status = ? WHERE id = ?");
            $stmt->execute([$newStatus, $id]);

            $delta = applyTransactionStatusBalanceDelta(
                $pdo,
                'uba_account_settings',
                $transaction['amount'],
                $oldStatus,
                $newStatus
            );

            $pdo->commit();

            $stmt = $pdo->prepare("SELECT * FROM uba_transactions WHERE id = ?");
            $stmt->execute([$id]);
            $updated = $stmt->fetch();

            $msg = 'Transaction status updated';
            if ($delta > 0) {
                $msg .= '. Balance refunded.';
            } elseif ($delta < 0) {
                $msg .= '. Balance deducted.';
            }

            sendResponse(true, $updated, $msg);
        } catch (Exception $e) {
            $pdo->rollBack();
            handleError('Failed to update transaction status: ' . $e->getMessage(), 500);
        }
        break;
        
    case 'DELETE':
        // Delete transaction (Admin only) and restore balance only if funds were still held
        validateAdminSession();
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        
        if (!$id) {
            handleError('Transaction ID is required');
        }
        
        try {
            $pdo->beginTransaction();
            
            $stmt = $pdo->prepare("SELECT amount, status FROM uba_transactions WHERE id = ?");
            $stmt->execute([$id]);
            $transaction = $stmt->fetch();
            
            if (!$transaction) {
                $pdo->rollBack();
                handleError('Transaction not found', 404);
            }
            
            $stmt = $pdo->prepare("DELETE FROM uba_transactions WHERE id = ?");
            $stmt->execute([$id]);

            if (transactionStatusHoldsFunds($transaction['status'] ?? 'SUCCESSFUL')) {
                $stmt = $pdo->query("SELECT id FROM uba_account_settings ORDER BY id DESC LIMIT 1");
                $accountRow = $stmt->fetch();
                $accountId = $accountRow['id'];
                
                $stmt = $pdo->prepare("UPDATE uba_account_settings SET balance = balance + ?, updated_at = NOW() WHERE id = ?");
                $stmt->execute([floatval($transaction['amount']), $accountId]);
            }
            
            $pdo->commit();
            
            sendResponse(true, null, 'Transaction deleted successfully');
        } catch (PDOException $e) {
            $pdo->rollBack();
            handleError('Failed to delete transaction: ' . $e->getMessage(), 500);
        }
        break;
        
    default:
        handleError('Method not allowed', 405);
}


