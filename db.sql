-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 10, 2025 at 10:19 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `projectlfms`
--

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

CREATE TABLE `attachments` (
  `attachment_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `uploaded_by` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `attachment_type` enum('initial_request','legal_feedback','user_feedback') NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attachments`
--


-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--
-- Error reading structure for table projectlfms.feedback: #1932 - Table &#039;projectlfms.feedback&#039; doesn&#039;t exist in engine
-- Error reading data for table projectlfms.feedback: #1064 - You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near &#039;FROM `projectlfms`.`feedback`&#039; at line 1

-- --------------------------------------------------------

--
-- Table structure for table `feedbacks`
--

CREATE TABLE `feedbacks` (
  `feedback_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `provided_by` int(11) NOT NULL,
  `comment` text NOT NULL,
  `feedback_type` enum('legal','user') NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedbacks`
--


-- --------------------------------------------------------

--
-- Table structure for table `final_documents`
--

CREATE TABLE `final_documents` (
  `final_doc_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `legal_team_id` int(11) NOT NULL,
  `validity_start` date NOT NULL,
  `validity_end` date NOT NULL,
  `final_file_path` varchar(255) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `final_documents`
--


-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `request_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `request_title` varchar(150) NOT NULL,
  `document_type` varchar(30) NOT NULL,
  `document_value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `status` enum('supervisor_approval_pending','ceo_approved','supervisor_approved','ceo_approval_pending','legal_feedback_given','rejected','final_documents_avaiable') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_name` varchar(30) DEFAULT NULL,
  `approved_by_supervisor` varchar(35) DEFAULT NULL,
  `approved_by_ceo` varchar(35) DEFAULT NULL,
  `approval_date` datetime DEFAULT NULL,
  `legal_feedback_by` varchar(100) DEFAULT NULL,
  `legal_feedback_date` datetime DEFAULT NULL,
  `user_feedback_date` datetime DEFAULT NULL,
  `final_submitted_by` varchar(100) DEFAULT NULL,
  `final_submitted_at` datetime DEFAULT NULL,
  `legal_feedback` text DEFAULT NULL,
  `user_feedback` text DEFAULT NULL,
  `final_file_path` varchar(255) DEFAULT NULL,
  `supervisor_approval_date` datetime DEFAULT NULL,
  `ceo_approval_date` datetime DEFAULT NULL,
  `rejected_by` int(11) DEFAULT NULL,
  `rejected_at` datetime DEFAULT NULL,
  `rejected_reason` text DEFAULT NULL,
  `approval_note` varchar(100) DEFAULT NULL,
  `ceo_approval_note` varchar(100) DEFAULT NULL,
  `type_of_the_agreement` enum('service','nda','distribution','transport','lease','house_rent','office_rent','supply','purchase') DEFAULT NULL,
  `name_of_the_other_parties` tinytext DEFAULT NULL,
  `Partys_tpdd_status` enum('done','not_done','not_required') DEFAULT NULL,
  `scope_of_work` text DEFAULT NULL,
  `work_schedule_if_any` text DEFAULT NULL,
  `performed_by` enum('service_provider_&_its_agent','representative') DEFAULT NULL,
  `tenure_value` int(11) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `effective_date` datetime DEFAULT NULL,
  `amount_to_be_paid` decimal(15,2) DEFAULT NULL,
  `ait` decimal(15,2) DEFAULT NULL,
  `vat` decimal(15,2) DEFAULT NULL,
  `other_costs` varchar(100) DEFAULT NULL,
  `total_amount_including_vat_and_tax` decimal(15,2) DEFAULT NULL,
  `payment_frequency` enum('monthly','quarterly','half_yearly','yearly','once_in_agreement_period','twice_in_agreement_period') DEFAULT NULL,
  `advance_payment` decimal(15,2) DEFAULT NULL,
  `security_deposit` decimal(15,2) DEFAULT NULL,
  `security_cheque_or_bank_guarantee` decimal(15,2) DEFAULT NULL,
  `penalty_deduction_matrix_for_default` varchar(100) DEFAULT NULL,
  `termination_notice_period` tinytext DEFAULT NULL,
  `consequences_of_termination` tinytext DEFAULT NULL,
  `assets_to_be_returned` tinytext DEFAULT NULL,
  `name_of_the_notice_receivers` tinytext DEFAULT NULL,
  `designations_of_receivers` tinytext DEFAULT NULL,
  `exclusivity` text DEFAULT NULL,
  `goal_sheet` text DEFAULT NULL,
  `any_other_special_clause` text DEFAULT NULL,
  `notice_receiver_mobile_no` varchar(11) DEFAULT NULL,
  `notice_receiver_email` varchar(35) DEFAULT NULL,
  `notice_receiver_address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `requests`
--


-- --------------------------------------------------------

--
-- Table structure for table `request_activity_log`
--

CREATE TABLE `request_activity_log` (
  `log_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `action_type` enum('request_created','supervisor_approved','supervisor_rejected','ceo_approved','ceo_rejected','legal_feedback_added','user_feedback_added','final_document_uploaded','request_rejected') NOT NULL,
  `performed_by` int(11) NOT NULL,
  `action_details` text DEFAULT NULL,
  `attachment_path` varchar(255) DEFAULT NULL,
  `action_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `request_activity_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(35) NOT NULL,
  `designation` varchar(35) DEFAULT NULL,
  `department` varchar(30) DEFAULT NULL,
  `supervisor_name` varchar(30) DEFAULT NULL,
  `supervisor_email` varchar(35) DEFAULT NULL,
  `company` varchar(30) DEFAULT NULL,
  `location` varchar(23) DEFAULT NULL,
  `email` varchar(35) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_approved` tinyint(1) DEFAULT 0,
  `role` enum('user','supervisor','legal_team','admin','ceo') DEFAULT 'user',
  `view_access` enum('Yes','No') NOT NULL DEFAULT 'No',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--


--
-- Indexes for dumped tables
--

--
-- Indexes for table `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`attachment_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `uploaded_by` (`uploaded_by`);

--
-- Indexes for table `final_documents`
--
ALTER TABLE `final_documents`
  ADD PRIMARY KEY (`final_doc_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `legal_team_id` (`legal_team_id`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `request_activity_log`
--
ALTER TABLE `request_activity_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `performed_by` (`performed_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attachments`
--
ALTER TABLE `attachments`
  MODIFY `attachment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT for table `final_documents`
--
ALTER TABLE `final_documents`
  MODIFY `final_doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `requests`
--
ALTER TABLE `requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `request_activity_log`
--
ALTER TABLE `request_activity_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=179;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attachments`
--
ALTER TABLE `attachments`
  ADD CONSTRAINT `attachments_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`),
  ADD CONSTRAINT `attachments_ibfk_2` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `fk_request_id` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`);

--
-- Constraints for table `final_documents`
--
ALTER TABLE `final_documents`
  ADD CONSTRAINT `final_documents_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`),
  ADD CONSTRAINT `final_documents_ibfk_2` FOREIGN KEY (`legal_team_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `fk_request_id_final` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`);

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `request_activity_log`
--
ALTER TABLE `request_activity_log`
  ADD CONSTRAINT `request_activity_log_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`),
  ADD CONSTRAINT `request_activity_log_ibfk_2` FOREIGN KEY (`performed_by`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
