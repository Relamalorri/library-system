-- =============================================
-- Jeddah Central Library Management System
-- CREATE TABLE Scripts
-- CPCS-241: Database I | KAU | Spring 2021
-- =============================================

CREATE TABLE Categories (
    Category_ID VARCHAR2(10) PRIMARY KEY,
    Category_Name VARCHAR2(50) UNIQUE
);

CREATE TABLE Employee_Info (
    Role VARCHAR2(50) PRIMARY KEY,
    Shift VARCHAR2(20),
    Salary NUMBER CHECK (Salary >= 0)
);

CREATE TABLE Employee (
    EmployeeID VARCHAR2(10) PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Phone VARCHAR2(15),
    Email VARCHAR2(100) UNIQUE,
    Role VARCHAR2(50) NULL,
    Hire_Date DATE,
    CONSTRAINT fk_emp_role FOREIGN KEY (Role) 
        REFERENCES Employee_Info(Role) ON DELETE SET NULL
);

CREATE TABLE Member (
    MemberID VARCHAR2(10) PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) UNIQUE,
    PhoneNumber VARCHAR2(15),
    Address VARCHAR2(100)
);

CREATE TABLE Membership (
    MembershipID VARCHAR2(10) PRIMARY KEY,
    MemberID VARCHAR2(10) REFERENCES Member(MemberID),
    Registration_Date DATE,
    Expiration_Date DATE,
    Membership_Type VARCHAR2(50)
);

CREATE TABLE Books (
    BookID VARCHAR2(10) PRIMARY KEY,
    ISBN VARCHAR2(20) UNIQUE,
    Title VARCHAR2(100) NOT NULL,
    AvailableCopies NUMBER CHECK (AvailableCopies >= 0),
    Category_ID VARCHAR2(10) REFERENCES Categories(Category_ID)
);

CREATE TABLE Authors (
    AuthorID VARCHAR2(10) PRIMARY KEY,
    Name VARCHAR2(50),
    Phone VARCHAR2(15),
    Email VARCHAR2(100) UNIQUE
);

CREATE TABLE Author_Writes_Books (
    BookID VARCHAR2(10) REFERENCES Books(BookID),
    AuthorID VARCHAR2(10) REFERENCES Authors(AuthorID),
    PRIMARY KEY (BookID, AuthorID)
);

CREATE TABLE Reservations (
    ReservationID VARCHAR2(10) PRIMARY KEY,
    MemberID VARCHAR2(10) REFERENCES Member(MemberID),
    BookID VARCHAR2(10) REFERENCES Books(BookID),
    Reservation_Date DATE,
    Reservation_Status VARCHAR2(50)
);

CREATE TABLE Fee_Amount (
    FeeID VARCHAR2(10) PRIMARY KEY,
    MemberID VARCHAR2(10) REFERENCES Member(MemberID),
    Amount NUMBER(6,2) CHECK (Amount >= 0),
    Reason VARCHAR2(200),
    Payment_Status VARCHAR2(50),
    Payment_Date DATE,
    Replacement_Fees NUMBER(6,2),
    FeeDelayCalc VARCHAR2(50)
);

CREATE TABLE Borrowing_Records (
    BorrowingID VARCHAR2(10) PRIMARY KEY,
    MemberID VARCHAR2(10) REFERENCES Member(MemberID),
    BookID VARCHAR2(10) REFERENCES Books(BookID),
    Borrow_Date DATE,
    Due_Date DATE,
    Return_Date DATE,
    FeeID VARCHAR2(10) REFERENCES Fee_Amount(FeeID),
    Status VARCHAR2(50),
    Loan_Duration NUMBER CHECK (Loan_Duration = 21),
    Book_Condition VARCHAR2(50)
);

CREATE TABLE Events (
    EventID VARCHAR2(10) PRIMARY KEY,
    Event_Name VARCHAR2(100) NOT NULL,
    EventDate DATE,
    EventTime VARCHAR2(10),
    Location VARCHAR2(100),
    Organizer VARCHAR2(10) REFERENCES Employee(EmployeeID),
    Description VARCHAR2(500),
    Status VARCHAR2(50),
    Max_Attendees NUMBER CHECK (Max_Attendees >= 0)
);

CREATE TABLE Member_Attends_Events (
    EventID VARCHAR2(10) REFERENCES Events(EventID),
    MemberID VARCHAR2(10) REFERENCES Member(MemberID),
    PRIMARY KEY (EventID, MemberID)
);

CREATE TABLE Book_Purchases (
    PurchaseID VARCHAR2(10) PRIMARY KEY,
    MemberID VARCHAR2(10) REFERENCES Member(MemberID),
    BookID VARCHAR2(10) REFERENCES Books(BookID),
    PurDate DATE,
    Price NUMBER(8,2) CHECK (Price >= 0),
    Quantity NUMBER CHECK (Quantity > 0),
    Payment_Status VARCHAR2(50)
);

-- Add BorrowingID to Fee_Amount
ALTER TABLE Fee_Amount ADD BorrowingID VARCHAR2(10);
ALTER TABLE Fee_Amount ADD CONSTRAINT fk_borrowing_id 
    FOREIGN KEY (BorrowingID) REFERENCES Borrowing_Records(BorrowingID);
