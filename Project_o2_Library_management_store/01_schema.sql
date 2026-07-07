DROP TABLE IF EXISTS fine_payments CASCADE;
DROP TABLE IF EXISTS book_reservations CASCADE;
DROP TABLE IF EXISTS book_loans CASCADE;
DROP TABLE IF EXISTS book_authors CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS members CASCADE;

-- 1. Authors Table (With multiple null types)
CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(150) NOT NULL,
    nationality VARCHAR(100), 
    birth_year INT,
    biography TEXT -- Data cleaning operations ke liye
);

-- 2. Books Table (With Genre, Cost and Complex Constraints)
CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(50) UNIQUE,
    genre VARCHAR(100) NOT NULL, -- Tech, Fiction, History, Science
    publisher VARCHAR(150),   
    publication_year INT,
    purchase_cost DECIMAL(8,2) NOT NULL, -- Missing price analysis ke liye
    total_copies INT NOT NULL CHECK (total_copies >= 0),
    available_copies INT NOT NULL CHECK (available_copies <= total_copies),
    rating DECIMAL(3,2)        
);

-- 3. Many-to-Many Bridge Table (Books <-> Authors)
CREATE TABLE book_authors (
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    author_id INT REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- 4. Members Table (With Tiering and Contact Missing Status)
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),       
    phone VARCHAR(50),        
    membership_date DATE NOT NULL,
    membership_tier VARCHAR(50) DEFAULT 'Standard', -- VIP, Standard, Student
    status VARCHAR(50) DEFAULT 'Active' 
);

-- 5. Book Loans Table (Core Transactional Table)
CREATE TABLE book_loans (
    loan_id INT PRIMARY KEY,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    member_id INT REFERENCES members(member_id) ON DELETE CASCADE,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,         -- NULL means currently active loan
    accrued_fine DECIMAL(6,2) DEFAULT 0.00
);

-- 6. Reservations Table (Waitlist Logic for popular books)
CREATE TABLE book_reservations (
    reservation_id INT PRIMARY KEY,
    book_id INT REFERENCES books(book_id) ON DELETE CASCADE,
    member_id INT REFERENCES members(member_id) ON DELETE CASCADE,
    reservation_date DATE NOT NULL,
    reservation_status VARCHAR(50) DEFAULT 'Pending' -- Fulfilled, Pending, Expired
);

-- 7. Fine Payments Ledger Table (Accounting Audit Trail)
CREATE TABLE fine_payments (
    payment_id INT PRIMARY KEY,
    loan_id INT REFERENCES book_loans(loan_id) ON DELETE CASCADE,
    amount_paid DECIMAL(6,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) -- Cash, Credit Card, Digital Wallet, NULL (Unpaid settlement)
);
-- Schema created Successfully with complex relationships, constraints, and data cleaning considerations for a library management system.