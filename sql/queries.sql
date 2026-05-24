-- =============================================
-- Sample Analytical Queries
-- =============================================

-- 1. Categories with Above-Average Book Availability
SELECT c.Category_ID, c.Category_Name, AVG(b.AvailableCopies) AS AvgCopies
FROM Books b
JOIN Categories c ON b.Category_ID = c.Category_ID
GROUP BY c.Category_ID, c.Category_Name
HAVING AVG(b.AvailableCopies) > (
    SELECT AVG(AvailableCopies) FROM Books
);

-- 2. Members Who Attended Events Organized by Well-Paid Employees (Salary > 7000)
SELECT DISTINCT m.MemberID, m.Name
FROM Member m
JOIN Member_Attends_Events mae ON m.MemberID = mae.MemberID
WHERE mae.EventID IN (
    SELECT e.EventID
    FROM Events e
    WHERE e.Organizer IN (
        SELECT emp.EmployeeID
        FROM Employee emp
        JOIN Employee_Info ei ON emp.Role = ei.Role
        WHERE ei.Salary > 7000
    )
);

-- 3. Transactions with the Highest Fee
SELECT br.BorrowingID, m.Name AS MemberName, 
       b.Title AS BookTitle, f.Amount AS FeeAmount
FROM Borrowing_Records br
JOIN Member m ON br.MemberID = m.MemberID
JOIN Books b ON br.BookID = b.BookID
JOIN Fee_Amount f ON br.FeeID = f.FeeID
WHERE f.Amount = (SELECT MAX(Amount) FROM Fee_Amount);

-- 4. Members with Below-Average Fees
SELECT m.MemberID, m.Name
FROM Member m
WHERE m.MemberID IN (
    SELECT f.MemberID
    FROM Fee_Amount f
    WHERE f.Amount < (SELECT AVG(Amount) FROM Fee_Amount)
);

-- 5. Employees Who Organized Large Events
SELECT DISTINCT e.EmployeeID, e.Name
FROM Employee e
JOIN Events ev ON e.EmployeeID = ev.Organizer
WHERE ev.Max_Attendees > (
    SELECT AVG(Max_Attendees) FROM Events
);
