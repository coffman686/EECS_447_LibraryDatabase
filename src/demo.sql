USE Library;

-- Test Query 1
SELECT
    u.Name AS Member_Name,
    SUM(DATEDIFF(CURDATE(), b.Due_Date) * 0.25) AS Total_Fines
FROM
    Borrow b
        JOIN Transaction t ON b.Transaction_ID = t.Transaction_ID
        JOIN Performs p ON t.Transaction_ID = p.Transaction_ID
        JOIN Member m ON p.User_ID = m.User_ID
        JOIN User u ON m.User_ID = u.User_ID
WHERE
    b.Due_Date < CURDATE() AND b.Return_Date IS NULL
GROUP BY
    m.User_ID, u.Name;

-- Test Query 2
SELECT
    b.Title,
    g.Genre_Name,
    i.Availability_Status
FROM
    Book b
        JOIN Belongs bl ON b.Item_ID = bl.Item_ID
        JOIN Genre g ON bl.Genre_Name = g.Genre_Name
        JOIN Item i ON b.Item_ID = i.Item_ID
WHERE
    i.Availability_Status = 'Available'
  AND g.Genre_Name = 'Mystery';

-- Test Query 3
SELECT
    u.Name AS Member_Name,
    COUNT(*) AS Books_Borrowed
FROM
    Borrow b
        JOIN Transaction t ON b.Transaction_ID = t.Transaction_ID
        JOIN Performs p ON t.Transaction_ID = p.Transaction_ID
        JOIN Member m ON p.User_ID = m.User_ID
        JOIN User u ON m.User_ID = u.User_ID
        JOIN Transaction_Involves_Item tii ON t.Transaction_ID = tii.Transaction_ID
        JOIN Belongs bl ON tii.Item_ID = bl.Item_ID
WHERE
    bl.Genre_Name = 'Mystery'
  AND t.Transaction_Date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY
    m.User_ID, u.Name
ORDER BY
    Books_Borrowed DESC
LIMIT 3;

-- Test Query 4
SELECT
    b.Title,
    br.Due_Date
FROM
    Borrow br
        JOIN Transaction t ON br.Transaction_ID = t.Transaction_ID
        JOIN Transaction_Involves_Item tii ON t.Transaction_ID = tii.Transaction_ID
        JOIN Book b ON tii.Item_ID = b.Item_ID
WHERE
    br.Due_Date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY
    br.Due_Date;

-- Test Query 5
SELECT
    u.Name AS Member_Name,
    b.Title AS Overdue_Book_Title
FROM
    Borrow br
        JOIN Transaction t ON br.Transaction_ID = t.Transaction_ID
        JOIN Performs p ON t.Transaction_ID = p.Transaction_ID
        JOIN Member m ON p.User_ID = m.User_ID
        JOIN User u ON m.User_ID = u.User_ID
        JOIN Transaction_Involves_Item tii ON t.Transaction_ID = tii.Transaction_ID
        JOIN Book b ON tii.Item_ID = b.Item_ID
WHERE
    br.Due_Date < CURDATE()
  AND br.Return_Date IS NULL;

-- Test Query 6
SELECT
    g.Genre_Name,
    AVG(DATEDIFF(br.Return_Date, br.Borrow_Date)) AS Avg_Borrow_Days
FROM
    Borrow br
        JOIN Transaction t ON br.Transaction_ID = t.Transaction_ID
        JOIN Transaction_Involves_Item tii ON t.Transaction_ID = tii.Transaction_ID
        JOIN Belongs bl ON tii.Item_ID = bl.Item_ID
        JOIN Genre g ON bl.Genre_Name = g.Genre_Name
WHERE
    g.Genre_Name = 'Mystery'
  AND br.Return_Date IS NOT NULL
GROUP BY
    g.Genre_Name;

-- Test Query 7
SELECT
    a.Name AS Author_Name,
    COUNT(*) AS Books_Borrowed
FROM
    Borrow br
        JOIN Transaction t ON br.Transaction_ID = t.Transaction_ID
        JOIN Transaction_Involves_Item tii ON t.Transaction_ID = tii.Transaction_ID
        JOIN Author_Writes_Item awi ON tii.Item_ID = awi.Item_ID
        JOIN Author a ON awi.Author_ID = a.Author_ID
WHERE
    t.Transaction_Date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY
    a.Author_ID, a.Name
ORDER BY
    Books_Borrowed DESC
LIMIT 1;


-- Queries for Demo

-- Distribution of Books by Genre
SELECT
    g.Genre_Name AS Genre,
    COUNT(*) AS Book_Count
FROM
    Book b
        JOIN Belongs bl ON b.Item_ID = bl.Item_ID
        JOIN Genre g ON bl.Genre_Name = g.Genre_Name
GROUP BY
    g.Genre_Name
ORDER BY
    Book_Count DESC;

-- Trends in Acquisition Over the Past 5 Years
SELECT
    i.Year AS Publication_Year,
    COUNT(*) AS Books_Acquired
FROM
    Item i
WHERE
    i.Item_Type = 'Book' AND i.Year >= YEAR(CURDATE()) - 5
GROUP BY
    i.Year
ORDER BY
    i.Year DESC;

-- Average Age of the Book Collection
SELECT
    AVG(YEAR(CURDATE()) - i.Year) AS Average_Age
FROM
    Item i
WHERE
    i.Item_Type = 'Book';

-- Identify Books with Zero Circulation
SELECT
    b.Title AS Book_Title,
    a.Name AS Author_Name
FROM
    Book b
        LEFT JOIN Transaction_Involves_Item tii ON b.Item_ID = tii.Item_ID
        LEFT JOIN Transaction t ON tii.Transaction_ID = t.Transaction_ID
        LEFT JOIN Author_Writes_Item awi ON b.Item_ID = awi.Item_ID
        LEFT JOIN Author a ON awi.Author_ID = a.Author_ID
WHERE
    t.Transaction_ID IS NULL;

-- Analyze Borrowing Patterns
SELECT
    g.Genre_Name AS Genre,
    COUNT(*) AS Borrowed_Count
FROM
    Borrow br
        JOIN Transaction t ON br.Transaction_ID = t.Transaction_ID
        JOIN Transaction_Involves_Item tii ON t.Transaction_ID = tii.Transaction_ID
        JOIN Belongs bl ON tii.Item_ID = bl.Item_ID
        JOIN Genre g ON bl.Genre_Name = g.Genre_Name
WHERE
    t.Transaction_Date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY
    g.Genre_Name
ORDER BY
    Borrowed_Count DESC;

-- Under-represented Genres or Authors (Low Borrow Counts)
SELECT
    g.Genre_Name AS Genre,
    COUNT(*) AS Borrowed_Count
FROM
    Belongs bl
        JOIN Genre g ON bl.Genre_Name = g.Genre_Name
        LEFT JOIN Transaction_Involves_Item tii ON bl.Item_ID = tii.Item_ID
        LEFT JOIN Borrow br ON tii.Transaction_ID = br.Transaction_ID
WHERE
    br.Transaction_ID IS NULL
GROUP BY
    g.Genre_Name
ORDER BY
    Borrowed_Count ASC;

-- Under-represented Genres or Authors (Low Borrow Counts)
SELECT
    a.Name AS Author,
    COUNT(br.Transaction_ID) AS Borrowed_Count
FROM
    Author a
        LEFT JOIN Author_Writes_Item awi ON a.Author_ID = awi.Author_ID
        LEFT JOIN Transaction_Involves_Item tii ON awi.Item_ID = tii.Item_ID
        LEFT JOIN Borrow br ON tii.Transaction_ID = br.Transaction_ID
GROUP BY
    a.Author_ID, a.Name
ORDER BY
    Borrowed_Count ASC;




