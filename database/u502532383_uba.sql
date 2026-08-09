-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 16, 2026 at 10:02 PM
-- Server version: 11.8.3-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u502532383_uba`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_sessions`
--

CREATE TABLE `admin_sessions` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `session_id` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password`, `email`, `created_at`, `last_login`) VALUES
(1, 'admin', 'Secretpass0721//', 'admin@ubadashboard.com', '2025-11-28 22:40:23', '2026-01-16 21:13:09');

-- --------------------------------------------------------

--
-- Table structure for table `bank_status`
--

CREATE TABLE `bank_status` (
  `id` int(11) NOT NULL,
  `bank_code` varchar(20) NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `status` enum('full_logs','weak_logs','pending_request','post_no_debit','fixed_account') NOT NULL DEFAULT 'full_logs',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bank_status`
--

INSERT INTO `bank_status` (`id`, `bank_code`, `bank_name`, `status`, `created_at`, `updated_at`) VALUES
(1, '033', 'UBA', 'post_no_debit', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(2, '011', 'First Bank', 'weak_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(3, '044', 'Access Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(4, '070', 'Fidelity Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(5, '058', 'Guaranty Trust Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(6, '030', 'Heritage Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(7, '301', 'Jaiz Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(8, '082', 'Keystone Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(9, '232', 'Sterling Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(10, '032', 'Union Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(11, '215', 'Unity Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(12, '035', 'Wema Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(13, '057', 'Zenith Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(14, '50211', 'Kuda Bank', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(15, '50515', 'Moniepoint', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(16, '999992', 'OPay', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51'),
(17, '100033', 'PalmPay', 'full_logs', '2025-12-04 22:12:52', '2025-12-31 04:22:51');

-- --------------------------------------------------------

--
-- Table structure for table `first_bank_account_settings`
--

CREATE TABLE `first_bank_account_settings` (
  `id` int(11) NOT NULL,
  `account_name` varchar(255) NOT NULL DEFAULT 'AUTOGRAPH CONSTRUCTION LIMITED',
  `account_number` varchar(50) NOT NULL DEFAULT '1022090307',
  `balance` decimal(15,2) NOT NULL DEFAULT 4192401.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `first_bank_account_settings`
--

INSERT INTO `first_bank_account_settings` (`id`, `account_name`, `account_number`, `balance`, `created_at`, `updated_at`) VALUES
(1, 'Ajima Nnabuike', '3104650005', 42762576543.65, '2025-12-03 23:30:00', '2025-12-31 04:22:15');

-- --------------------------------------------------------

--
-- Table structure for table `first_bank_transactions`
--

CREATE TABLE `first_bank_transactions` (
  `id` int(11) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'NGN',
  `beneficiary_name` varchar(255) NOT NULL,
  `beneficiary_bank` varchar(255) NOT NULL,
  `beneficiary_account` varchar(50) NOT NULL,
  `sender_account` varchar(50) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `purpose` varchar(500) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'SUCCESSFUL',
  `transaction_date` timestamp NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `zenith_bank_account_settings`
--

CREATE TABLE `zenith_bank_account_settings` (
  `id` int(11) NOT NULL,
  `account_name` varchar(255) NOT NULL DEFAULT 'AUTOGRAPH CONSTRUCTION LIMITED',
  `account_number` varchar(50) NOT NULL DEFAULT '1022090307',
  `balance` decimal(15,2) NOT NULL DEFAULT 4192401.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `zenith_bank_account_settings`
--

INSERT INTO `zenith_bank_account_settings` (`id`, `account_name`, `account_number`, `balance`, `created_at`, `updated_at`) VALUES
(1, 'AUTOGRAPH CONSTRUCTION LIMITED', '1022090307', 4192401.00, '2026-02-05 00:00:00', '2026-02-05 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `zenith_bank_transactions`
--

CREATE TABLE `zenith_bank_transactions` (
  `id` int(11) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'NGN',
  `beneficiary_name` varchar(255) NOT NULL,
  `beneficiary_bank` varchar(255) NOT NULL,
  `beneficiary_account` varchar(50) NOT NULL,
  `sender_account` varchar(50) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `purpose` varchar(500) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'SUCCESSFUL',
  `transaction_date` timestamp NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `access_bank_account_settings`
--

CREATE TABLE `access_bank_account_settings` (
  `id` int(11) NOT NULL,
  `account_name` varchar(255) NOT NULL DEFAULT 'AUTOGRAPH CONSTRUCTION LIMITED',
  `account_number` varchar(50) NOT NULL DEFAULT '1022090307',
  `balance` decimal(15,2) NOT NULL DEFAULT 4192401.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `access_bank_account_settings`
--

INSERT INTO `access_bank_account_settings` (`id`, `account_name`, `account_number`, `balance`, `created_at`, `updated_at`) VALUES
(1, 'AUTOGRAPH CONSTRUCTION LIMITED', '1022090307', 4192401.00, '2026-02-05 00:00:00', '2026-02-05 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `access_bank_transactions`
--

CREATE TABLE `access_bank_transactions` (
  `id` int(11) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'NGN',
  `beneficiary_name` varchar(255) NOT NULL,
  `beneficiary_bank` varchar(255) NOT NULL,
  `beneficiary_account` varchar(50) NOT NULL,
  `sender_account` varchar(50) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `purpose` varchar(500) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'SUCCESSFUL',
  `transaction_date` timestamp NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `license_keys`
--

CREATE TABLE `license_keys` (
  `id` int(11) NOT NULL,
  `license_key` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `license_keys`
--

INSERT INTO `license_keys` (`id`, `license_key`, `is_active`, `created_at`) VALUES
(1, '47637335b3eac7cba69ba88e24323489c341386b2e5a2bfb4495212b86e6091d', 0, '2025-12-05 20:29:19'),
(2, '7173beb07af40fac3a24a09684daae051a7c58a86656e774fe2b5778898bcef0', 0, '2025-12-05 20:58:31'),
(3, '902d0387f7ca1f906d39942440c497ac115f26db29c5ae35a8cf105ae5e6d026', 0, '2025-12-08 19:45:45'),
(4, '62627a3179e9ed8b0debd4f50a9dd8548b197c7b4a07df5b0da3f94139572293', 0, '2025-12-09 20:19:28'),
(5, '52aa864778c4adccf93b110146a240e8cc32ba18523e10c4f12f39e48bce9c6c', 0, '2025-12-12 23:08:40'),
(6, 'd3dc81785d1094f10a1f083c1095db0ac20dae89c45340f187819d67733e69b8', 0, '2025-12-13 07:19:28'),
(7, 'de60b95f555f7276984f134964b8cacce5d46121b80b1dbd01f51c43c745d9c8', 0, '2025-12-13 07:25:26'),
(8, 'f8f503e2196383a20110e95c1f06ea9defe5a7308dc6645b2b37bb4770471b42', 0, '2025-12-17 19:27:26'),
(9, '84d57745fc28a4f78ae2dc7734cfbed8076e7fd44c42a8c968838706293e79b1', 0, '2025-12-23 09:29:15'),
(10, 'e32e6a4a7b54e73bd432df8e2b2f97405c16b20293bdeb7613a20fba81f19e38', 0, '2025-12-31 04:23:13'),
(11, 'e23bc48b6f1dac9bd02e3c543bdc3b4fa5d9a36b927766785b632bb352b3b92c', 1, '2026-01-16 21:20:37');

-- --------------------------------------------------------

--
-- Table structure for table `license_settings`
--

CREATE TABLE `license_settings` (
  `id` int(11) NOT NULL,
  `purchase_email` varchar(255) NOT NULL DEFAULT 'support@ubadashboard.com',
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `license_settings`
--

INSERT INTO `license_settings` (`id`, `purchase_email`, `updated_at`) VALUES
(1, 'evacuation.log@atomicmail.io', '2025-12-05 21:00:12');

-- --------------------------------------------------------

--
-- Table structure for table `uba_account_settings`
--

CREATE TABLE `uba_account_settings` (
  `id` int(11) NOT NULL,
  `account_name` varchar(255) NOT NULL DEFAULT 'AUTOGRAPH CONSTRUCTION LIMITED',
  `account_number` varchar(50) NOT NULL DEFAULT '1022090307',
  `balance` decimal(15,2) NOT NULL DEFAULT 670473471.10,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `uba_account_settings`
--

INSERT INTO `uba_account_settings` (`id`, `account_name`, `account_number`, `balance`, `created_at`, `updated_at`) VALUES
(1, 'ABDULLAHI TSAFE ABDULKARIM', '1025973481', 57878351990.00, '2025-11-28 22:40:23', '2025-12-05 21:25:58');

-- --------------------------------------------------------

--
-- Table structure for table `uba_transactions`
--

CREATE TABLE `uba_transactions` (
  `id` int(11) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'NGN',
  `beneficiary_name` varchar(255) NOT NULL,
  `beneficiary_bank` varchar(255) NOT NULL,
  `beneficiary_account` varchar(50) NOT NULL,
  `sender_account` varchar(50) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `purpose` varchar(500) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'SUCCESSFUL',
  `transaction_date` timestamp NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `uba_transactions`
--

INSERT INTO `uba_transactions` (`id`, `reference`, `amount`, `currency`, `beneficiary_name`, `beneficiary_bank`, `beneficiary_account`, `sender_account`, `sender_name`, `purpose`, `status`, `transaction_date`, `created_at`) VALUES
(2, '4765586166', 780000.00, 'NGN', 'IFEANYI ELVIS OZOEMENA', 'OPay', '8104696744', '1022090307', 'AUTOGRAPH CONSTRUCTION LIMITED', 'Soler ', 'SUCCESSFUL', '2025-11-29 10:42:20', '2025-11-29 10:42:20'),
(3, '4797943126', 500000.00, 'NGN', 'RUFAI DESMOND IBRAHIM', 'OPay', '8141607598', '1022090307', 'AUTOGRAPH CONSTRUCTION LIMITED', NULL, 'SUCCESSFUL', '2025-11-29 13:33:17', '2025-11-29 13:33:17'),
(4, '1076577534', 500.00, 'NGN', 'JAMES MUSA SAMAILA', 'OPay', '9122083549', '1022090307', 'AUTOGRAPH CONSTRUCTION LIMITED', NULL, 'SUCCESSFUL', '2025-12-05 15:04:23', '2025-12-05 15:04:23');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `license_key_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `license_key_id`, `created_at`, `last_login`, `password_changed_at`) VALUES
(7, 'EVACU222???', 'PASSCODE11??', 11, '2026-01-16 21:15:17', '2026-01-16 21:22:23', '2026-01-16 21:16:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `bank_status`
--
ALTER TABLE `bank_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bank_code` (`bank_code`);

--
-- Indexes for table `first_bank_account_settings`
--
ALTER TABLE `first_bank_account_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `first_bank_transactions`
--
ALTER TABLE `first_bank_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`);

--
-- Indexes for table `zenith_bank_account_settings`
--
ALTER TABLE `zenith_bank_account_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `zenith_bank_transactions`
--
ALTER TABLE `zenith_bank_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`);

--
-- Indexes for table `access_bank_account_settings`
--
ALTER TABLE `access_bank_account_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `access_bank_transactions`
--
ALTER TABLE `access_bank_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`);

--
-- Indexes for table `license_keys`
--
ALTER TABLE `license_keys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `license_key` (`license_key`);

--
-- Indexes for table `license_settings`
--
ALTER TABLE `license_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `uba_account_settings`
--
ALTER TABLE `uba_account_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `uba_transactions`
--
ALTER TABLE `uba_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `license_key_id` (`license_key_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_sessions`
--
ALTER TABLE `admin_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bank_status`
--
ALTER TABLE `bank_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=358;

--
-- AUTO_INCREMENT for table `first_bank_account_settings`
--
ALTER TABLE `first_bank_account_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `first_bank_transactions`
--
ALTER TABLE `first_bank_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `zenith_bank_account_settings`
--
ALTER TABLE `zenith_bank_account_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `zenith_bank_transactions`
--
ALTER TABLE `zenith_bank_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `access_bank_account_settings`
--
ALTER TABLE `access_bank_account_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `access_bank_transactions`
--
ALTER TABLE `access_bank_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `license_keys`
--
ALTER TABLE `license_keys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `license_settings`
--
ALTER TABLE `license_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `uba_account_settings`
--
ALTER TABLE `uba_account_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `uba_transactions`
--
ALTER TABLE `uba_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD CONSTRAINT `admin_sessions_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`license_key_id`) REFERENCES `license_keys` (`id`) ON DELETE SET NULL;

-- --------------------------------------------------------

--
-- Table structure for table `bvn_status`
--

CREATE TABLE `bvn_status` (
  `id` int(11) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bvn_status`
--

INSERT INTO `bvn_status` (`id`, `status`, `updated_at`) VALUES
(1, 'active', '2026-01-16 22:00:00');

--
-- Indexes for table `bvn_status`
--
ALTER TABLE `bvn_status`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for table `bvn_status`
--
ALTER TABLE `bvn_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

-- --------------------------------------------------------

--
-- Table structure for table `platform_status`
--

CREATE TABLE `platform_status` (
  `id` int(11) NOT NULL,
  `status` enum('on','off') NOT NULL DEFAULT 'on',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `platform_status`
--

INSERT INTO `platform_status` (`id`, `status`, `updated_at`) VALUES
(1, 'on', '2026-02-05 00:00:00');

--
-- Indexes for table `platform_status`
--
ALTER TABLE `platform_status`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for table `platform_status`
--
ALTER TABLE `platform_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

-- --------------------------------------------------------

--
-- Table structure for table `paystack_settings`
--

CREATE TABLE `paystack_settings` (
  `id` int(11) NOT NULL,
  `test_public_key` varchar(255) DEFAULT NULL,
  `test_secret_key` varchar(255) DEFAULT NULL,
  `live_public_key` varchar(255) DEFAULT NULL,
  `live_secret_key` varchar(255) DEFAULT NULL,
  `use_live` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `paystack_settings`
--

INSERT INTO `paystack_settings` (`id`, `test_public_key`, `test_secret_key`, `live_public_key`, `live_secret_key`, `use_live`, `updated_at`) VALUES
(1, NULL, NULL, NULL, NULL, 0, '2026-02-05 00:00:00');

--
-- Indexes for table `paystack_settings`
--
ALTER TABLE `paystack_settings`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for table `paystack_settings`
--
ALTER TABLE `paystack_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
