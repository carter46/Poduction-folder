<?php
/**
 * First Bank Transactions API
 * Handles transaction creation, retrieval, and deletion for First Bank
 */

require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];
$pdo = getDBConnection();

switch ($method) {
    case 'GET':
        // Get all transactions with pagination
        $limit = isset($_GET['limit']) ? intval($_GET['limit']) : 50;
        $offset = isset($_GET['offset']) ? intval($_GET['offset']) : 0;
        
        try {
            // Get total count
            $stmt = $pdo->query("SELECT COUNT(*) as total FROM first_bank_transactions");
            $total = $stmt->fetch()['total'];
            
            // Get transactions
            $stmt = $pdo->prepare("SELECT * FROM first_bank_transactions ORDER BY transaction_date DESC LIMIT ? OFFSET ?");
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
                INSERT INTO first_bank_transactions (
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
            $stmt = $pdo->query("SELECT id FROM first_bank_account_settings ORDER BY id DESC LIMIT 1");
            $accountRow = $stmt->fetch();
            $accountId = $accountRow['id'];
            
            $stmt = $pdo->prepare("UPDATE first_bank_account_settings SET balance = balance - ?, updated_at = NOW() WHERE id = ?");
            $stmt->execute([floatval($input['amount']), $accountId]);
            
            $pdo->commit();
            
            // Get created transaction
            $stmt = $pdo->prepare("SELECT * FROM first_bank_transactions WHERE id = ?");
            $stmt->execute([$transactionId]);
            $transaction = $stmt->fetch();
            
            sendResponse(true, $transaction, 'Transaction created successfully');
        } catch (PDOException $e) {
            $pdo->rollBack();
            handleError('Failed to create transaction: ' . $e->getMessage(), 500);
        }
        break;
        
    case 'DELETE':
        // Delete transaction (Admin only) and restore balance
        validateAdminSession();
        
        $id = isset($_GET['id']) ? intval($_GET['id']) : 0;
        
        if (!$id) {
            handleError('Transaction ID is required');
        }
        
        try {
            $pdo->beginTransaction();
            
            // Get transaction details
            $stmt = $pdo->prepare("SELECT amount FROM first_bank_transactions WHERE id = ?");
            $stmt->execute([$id]);
            $transaction = $stmt->fetch();
            
            if (!$transaction) {
                $pdo->rollBack();
                handleError('Transaction not found', 404);
            }
            
            // Delete transaction
            $stmt = $pdo->prepare("DELETE FROM first_bank_transactions WHERE id = ?");
            $stmt->execute([$id]);
            
            // Restore balance (most recent account setting)
            $stmt = $pdo->query("SELECT id FROM first_bank_account_settings ORDER BY id DESC LIMIT 1");
            $accountRow = $stmt->fetch();
            $accountId = $accountRow['id'];
            
            $stmt = $pdo->prepare("UPDATE first_bank_account_settings SET balance = balance + ?, updated_at = NOW() WHERE id = ?");
            $stmt->execute([floatval($transaction['amount']), $accountId]);
            
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

