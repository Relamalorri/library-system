-- =============================================
-- Business Rule Constraints & Triggers
-- =============================================

-- Rule 2: Max 3 active loans per member
CREATE OR REPLACE TRIGGER borrow_limit
BEFORE INSERT ON Borrowing_Records
FOR EACH ROW
DECLARE
    active_loans NUMBER;
BEGIN
    SELECT COUNT(*) INTO active_loans
    FROM Borrowing_Records
    WHERE MemberID = :NEW.MemberID AND Status = 'Borrowed';
    IF active_loans >= 3 THEN
        DBMS_OUTPUT.PUT_LINE('Borrow limit exceeded: Maximum 3 active loans allowed.');
    END IF;
END;
/

-- Rule 4: Fines must be settled before borrowing
CREATE OR REPLACE TRIGGER trg_unpaid_fees_check
BEFORE INSERT ON Borrowing_Records
FOR EACH ROW
DECLARE
    unpaid_fees NUMBER;
BEGIN
    SELECT COUNT(*) INTO unpaid_fees
    FROM Fee_Amount
    WHERE MemberID = :NEW.MemberID AND Payment_Status = 'Unpaid';
    IF unpaid_fees > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User must settle unpaid fines before borrowing.');
    END IF;
END;
/

-- Rule 5: Member must have membership to borrow
CREATE OR REPLACE TRIGGER trg_membership_notice
BEFORE INSERT ON Borrowing_Records
FOR EACH ROW
DECLARE
    membership_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO membership_count
    FROM Membership
    WHERE MemberID = :NEW.MemberID;
    IF membership_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Notice: Member does not have an active membership.');
    END IF;
END;
/

-- Rule 6: Reservations expire after 48 hours
CREATE OR REPLACE TRIGGER trg_auto_cancel_reservations
BEFORE UPDATE ON Reservations
FOR EACH ROW
BEGIN
    IF :NEW.Reservation_Status = 'Approved' AND
       (:NEW.Reservation_Date IS NOT NULL AND 
        SYSDATE - :NEW.Reservation_Date >= 2) THEN
        DBMS_OUTPUT.PUT_LINE('Reservation expired and will be auto-cancelled.');
        :NEW.Reservation_Status := 'Cancelled';
    END IF;
END;
/

-- Rule 9: Replacement fee for lost or damaged books
CREATE OR REPLACE TRIGGER trg_replacement_fee
AFTER UPDATE ON Borrowing_Records
FOR EACH ROW
BEGIN
    IF :NEW.Book_Condition = 'Lost' OR :NEW.Book_Condition = 'Damaged' THEN
        INSERT INTO Fee_Amount (
            FeeID, MemberID, BorrowingID, Amount, Reason, Payment_Status
        ) VALUES (
            'F' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),
            :NEW.MemberID,
            :NEW.BorrowingID,
            100,
            'Replacement Fee',
            'Unpaid'
        );
    END IF;
END;
/

-- Rule 10: Only admin can modify records
CREATE OR REPLACE TRIGGER trg_restrict_to_admin
BEFORE UPDATE ON Borrowing_Records
FOR EACH ROW
DECLARE
    user_role VARCHAR2(50);
BEGIN
    SELECT Role INTO user_role
    FROM Employee
    WHERE EmployeeID = :NEW.MemberID;
    IF user_role != 'Admin' THEN
        DBMS_OUTPUT.PUT_LINE('Only admin users can modify this record.');
    END IF;
END;
/

-- Rule 11: Purchased books cannot be returned
CREATE OR REPLACE TRIGGER prevent_purchase_delete
BEFORE DELETE ON Book_Purchases
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Notice: Purchased books cannot be returned.');
END;
/
