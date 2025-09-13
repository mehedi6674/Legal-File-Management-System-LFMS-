# Legal-File-Management-System-LFMS-
A full-stack ERP application for managing legal documents and workflows, built with Python, MySQL, HTML, and CSS.
code
Markdown
# Legal File Management System (LFMS)

## Overview

The Legal File Management System (LFMS) is a Flask-based web application designed to streamline the process of managing legal requests and documents within an organization. It provides a structured workflow for users to submit legal requests, supervisors and CEOs to approve them, the legal team to provide feedback and upload final documents, and administrators to manage users and system settings. The system includes features for document attachments, activity logging, email notifications, and Single Sign-On (SSO) integration with Microsoft Azure AD.

## Features

*   **User Management:**
    *   User registration and admin approval.
    *   Role-based access control (User, Supervisor, CEO, Legal Team, Admin).
    *   Admin panel for adding, editing, deleting (with integrity checks), locking, and resetting passwords for users.
    *   Password hashing with `werkzeug.security`.
*   **Request Management:**
    *   Submission of new legal requests with detailed forms (including fields for agreements, values, parties, scope, etc.).
    *   Attachment uploads for various document types (initial request, security cheques, supporting documents).
    *   Total attachment size limit.
    *   View detailed request information.
    *   Activity logging for all significant actions on a request.
*   **Approval Workflow:**
    *   Multi-stage approval process: Supervisor -> CEO (conditional on document value).
    *   Email notifications for approval actions.
    *   Feedback mechanism for both legal team and users.
*   **Document Management:**
    *   Legal team can upload final documents with validity periods.
    *   Centralized repository for all approved legal documents with search and filtering capabilities.
    *   Secure file uploads and downloads.
*   **Security:**
    *   Login required decorators for routes.
    *   Role-based access control for specific actions (e.g., admin_required).
    *   Secure password handling.
    *   Content Security Policy (CSP), X-Content-Type-Options, X-Frame-Options, X-XSS-Protection headers.
    *   Forgot password functionality with secure, time-limited tokens.
*   **Email Notifications:**
    *   Asynchronous email sending for user registration, password resets, request status updates, and feedback.
*   **Single Sign-On (SSO):**
    *   Integration with Microsoft Azure AD for seamless login for specified domains.
*   **Dashboard:**
    *   Role-specific dashboards providing relevant information and pending tasks.
*   **Responsive Design:**
    *   Utilizes Bootstrap for a modern and responsive user interface.

## Technologies Used

*   **Backend:** Flask (Python)
*   **Database:** MySQL
*   **Frontend:** HTML, CSS, JavaScript, Bootstrap
*   **Authentication:** `werkzeug.security`, `flask_mysqldb`, `msal` (for Microsoft SSO)
*   **Email:** `smtplib`, `email.message`
*   **Security Tokens:** `itsdangerous`
*   **File Management:** `werkzeug.utils`

## Setup and Installation

### Prerequisites

*   Python 3.x
*   MySQL Server
*   Microsoft Azure AD App Registration (for SSO functionality, optional but recommended)

### 1. Clone the Repository

```bash
git clone <repository_url>
cd LFMS
2. Create a Virtual Environment and Install Dependencies
code
Bash
python -m venv venv
source venv/bin/activate # On Windows: .\venv\Scripts\activate
pip install -r requirements.txt
(Create a requirements.txt if you don't have one: pip freeze > requirements.txt)
3. Database Setup
Create the Database
Log in to your MySQL server and create a new database (e.g., new).
code
SQL
CREATE DATABASE new;
USE new;
Database Schema
Execute the following SQL commands to create the necessary tables:
code
SQL
-- users table
CREATE TABLE `users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` ENUM('user', 'supervisor', 'ceo', 'legal_team', 'admin') DEFAULT 'user',
    `is_approved` TINYINT(1) DEFAULT 0, -- 0: pending, 1: approved, 2: rejected
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `designation` VARCHAR(255),
    `department` VARCHAR(255),
    `supervisor_name` VARCHAR(255),
    `supervisor_email` VARCHAR(255),
    `company` VARCHAR(255),
    `location` VARCHAR(255),
    `view_access` ENUM('Yes', 'No') DEFAULT 'No'
);

-- requests table
CREATE TABLE `requests` (
    `request_id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `user_name` VARCHAR(255) NOT NULL,
    `request_title` VARCHAR(255) NOT NULL,
    `document_type` VARCHAR(255),
    `document_value` DECIMAL(15, 2),
    `description` TEXT,
    `type_of_the_agreement` VARCHAR(255),
    `name_of_the_other_parties` VARCHAR(255),
    `Partys_tpdd_status` VARCHAR(255),
    `scope_of_work` TEXT,
    `work_schedule_if_any` TEXT,
    `performed_by` VARCHAR(255),
    `tenure_value` VARCHAR(255),
    `currency` VARCHAR(10) DEFAULT 'BDT',
    `effective_date` DATE,
    `amount_to_be_paid` DECIMAL(15, 2),
    `ait` DECIMAL(15, 2),
    `vat` DECIMAL(15, 2),
    `other_costs` DECIMAL(15, 2),
    `total_amount_including_vat_and_tax` DECIMAL(15, 2),
    `payment_frequency` VARCHAR(255),
    `advance_payment` VARCHAR(255),
    `security_deposit` VARCHAR(255),
    `security_cheque_or_bank_guarantee` VARCHAR(255),
    `penalty_deduction_matrix_for_default` TEXT,
    `termination_notice_period` VARCHAR(255),
    `consequences_of_termination` TEXT,
    `assets_to_be_returned` TEXT,
    `name_of_the_notice_receivers` VARCHAR(255),
    `designations_of_receivers` VARCHAR(255),
    `notice_receiver_mobile_no` VARCHAR(20),
    `notice_receiver_email` VARCHAR(255),
    `notice_receiver_address` TEXT,
    `exclusivity` TEXT,
    `goal_sheet` TEXT,
    `any_other_special_clause` TEXT,
    `status` ENUM('supervisor_approval_pending', 'ceo_approval_pending', 'supervisor_approved', 'ceo_approved', 'legal_feedback_given', 'final_documents_avaiable', 'rejected') DEFAULT 'supervisor_approval_pending',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `approved_by_supervisor` VARCHAR(255),
    `supervisor_approval_date` DATETIME,
    `approval_note` TEXT,
    `approved_by_ceo` VARCHAR(255),
    `ceo_approval_date` DATETIME,
    `ceo_approval_note` TEXT,
    `legal_feedback` TEXT,
    `legal_feedback_by` VARCHAR(255),
    `legal_feedback_date` DATETIME,
    `user_feedback` TEXT,
    `user_feedback_date` DATETIME,
    `final_file_path` VARCHAR(255), -- Storing path in requests for easy access
    `final_submitted_by` VARCHAR(255),
    `final_submitted_at` DATETIME,
    `rejected_by` INT,
    `rejected_reason` TEXT,
    `rejected_at` DATETIME,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`)
);

-- attachments table
CREATE TABLE `attachments` (
    `attachment_id` INT AUTO_INCREMENT PRIMARY KEY,
    `request_id` INT NOT NULL,
    `uploaded_by` INT NOT NULL,
    `file_path` VARCHAR(255) NOT NULL,
    `attachment_type` ENUM('initial_request', 'security_cheque', 'supporting_document', 'legal_feedback', 'user_feedback') NOT NULL,
    `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`request_id`) REFERENCES `requests`(`request_id`),
    FOREIGN KEY (`uploaded_by`) REFERENCES `users`(`user_id`)
);

-- feedbacks table (for specific feedback entries)
CREATE TABLE `feedbacks` (
    `feedback_id` INT AUTO_INCREMENT PRIMARY KEY,
    `request_id` INT NOT NULL,
    `provided_by` INT NOT NULL,
    `comment` TEXT NOT NULL,
    `feedback_type` ENUM('legal', 'user') NOT NULL,
    `submitted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`request_id`) REFERENCES `requests`(`request_id`),
    FOREIGN KEY (`provided_by`) REFERENCES `users`(`user_id`)
);

-- final_documents table
CREATE TABLE `final_documents` (
    `final_doc_id` INT AUTO_INCREMENT PRIMARY KEY,
    `request_id` INT NOT NULL,
    `legal_team_id` INT NOT NULL,
    `validity_start` DATE,
    `validity_end` DATE,
    `final_file_path` VARCHAR(255) NOT NULL,
    `uploaded_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`request_id`) REFERENCES `requests`(`request_id`),
    FOREIGN KEY (`legal_team_id`) REFERENCES `users`(`user_id`)
);

-- request_activity_log table
CREATE TABLE `request_activity_log` (
    `log_id` INT AUTO_INCREMENT PRIMARY KEY,
    `request_id` INT NOT NULL,
    `action_type` VARCHAR(255) NOT NULL, -- e.g., 'request_created', 'supervisor_approved', 'legal_feedback_added'
    `performed_by` INT NOT NULL,
    `action_details` TEXT,
    `attachment_path` VARCHAR(255), -- Optional: for actions involving file uploads
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`request_id`) REFERENCES `requests`(`request_id`),
    FOREIGN KEY (`performed_by`) REFERENCES `users`(`user_id`)
);
Add an Initial Admin User (Manual Insertion)
It's highly recommended to add at least one admin user directly to the database after creating the users table.
First, generate a password hash using Python:
code
Python
from werkzeug.security import generate_password_hash
print(generate_password_hash("your_admin_password"))
Then, insert into the users table:
code
SQL
INSERT INTO users (name, email, password_hash, role, is_approved)
VALUES ('Admin User', 'admin@example.com', 'YOUR_GENERATED_HASH', 'admin', 1);
Replace 'YOUR_GENERATED_HASH' with the hash you generated.
4. Configuration
Open app.py and update the following configuration variables:
app.secret_key: A strong, random secret key for Flask sessions.
app.config['SECURITY_PASSWORD_SALT']: Another strong, random secret for password reset tokens.
SMTP_SERVER, SMTP_PORT, SMTP_USER, SMTP_PASSWORD: Your SMTP server details for sending emails.
app.config['CLIENT_ID'], app.config['CLIENT_SECRET'], app.config['TENANT_ID']: Your Azure AD application credentials for SSO.
app.config['SSO_DOMAINS']: A list of email domains for which SSO should be enabled (e.g., ['yourcompany.com']).
app.config['MYSQL_HOST'], app.config['MYSQL_USER'], app.config['MYSQL_PASSWORD'], app.config['MYSQL_DB']: Your MySQL database connection details.
UPLOAD_FOLDER: The directory where uploaded files will be stored. Make sure it exists and is writable by the application.
MAX_TOTAL_ATTACHMENT_SIZE: Adjust the maximum allowed total attachment size (default is 2MB).
code
Python
app.secret_key = 'super_secret_key_change_this' # CHANGE THIS!
app.config['SECURITY_PASSWORD_SALT'] = 'another-very-secret-salt' # CHANGE THIS!

# SMTP Configuration - FILL THESE IN
SMTP_SERVER = "smtp.yourserver.com"
SMTP_PORT = 587
SMTP_USER = "your_email@example.com"
SMTP_PASSWORD = "your_email_password"

# MSAL / SSO Configuration - IMPORTANT: Fill these values from your Azure AD App Registration
app.config['CLIENT_ID'] = "YOUR_AZURE_APP_CLIENT_ID"
app.config['CLIENT_SECRET'] = "YOUR_AZURE_APP_CLIENT_SECRET"
app.config['TENANT_ID'] = "YOUR_AZURE_APP_TENANT_ID"
app.config['SSO_DOMAINS'] = ['yourcompany.com', 'anotherdomain.com'] # Example: ['your_company.com']

# MySQL config - change according to your setup
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '' # your password
app.config['MYSQL_DB'] = 'new'
5. Create static/uploads Directory
Ensure the upload folder exists:
code
Bash
mkdir -p static/uploads
6. Run the Application
code
Bash
python app.py
The application will typically run on http://127.0.0.1:5000/.
Usage
Register: New users can register via the /register route. Their accounts will be pending until an admin approves them.
Login: Users can log in with their email and password. If SSO is configured and their email domain matches, they will be redirected to Microsoft login.
Admin Approval: An administrator must log in (using the manually created admin account) and approve pending users via the /admin_approve route. Admins can also manage all users via /manage_users.
Dashboard: After logging in, users are redirected to their role-specific dashboard.
User: Can submit new requests and view their own requests.
Supervisor/CEO: Can view and approve requests pending their approval.
Legal Team: Can view requests needing legal review, provide feedback, and upload final documents.
Admin: Has access to all requests, user management, and pending user approvals.
New Request: Users can create new legal requests via /request/new or NDA-specific requests via /request/new_nda.
View Request: Click on any request from the dashboard to view its full details, attachments, and feedback.
Approval/Rejection: Supervisors and CEOs can approve or reject requests from the view_request page or their dashboard.
Legal Feedback/Final Upload: The legal team can provide feedback or upload final documents for approved requests.
All Legal Documents: Users with view_access='Yes' can browse all finalized legal documents via /all_legal_documents.
Manage Users (Admin): Admins can add, edit, lock/unlock, reset passwords, or delete users (if no associated records exist) from /manage_users.
Project Structure (Expected)
code
Code
LFMS/
├── app.py                      # Main Flask application file
├── requirements.txt            # Python dependencies
├── static/                     # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   ├── images/
│   └── uploads/                # UPLOAD_FOLDER for user attachments
├── templates/                  # HTML templates
│   ├── admin_approve.html
│   ├── add_user.html
│   ├── all_legal_documents.html
│   ├── all_requests.html
│   ├── dashboard.html
│   ├── edit_user.html
│   ├── forgot_password.html
│   ├── legal_feedback.html
│   ├── login.html
│   ├── manage_user.html
│   ├── my_approve_requests.html
│   ├── new_request.html
│   ├── new_request_fornda.html
│   ├── register.html
│   ├── reset_password_token.html
│   ├── user_feedback.html
│   └── view_request.html
└── README.md                   # This file
Contributing
Feel free to fork the repository, make improvements, and submit pull requests.
License
This project is open-source and available under the MIT License.
