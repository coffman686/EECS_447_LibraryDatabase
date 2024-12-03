-- Test Case Queries --
USE Library;
-- 1. Insert Data into Item Table --

INSERT INTO Item (Item_ID, Price, Year, Availability_Status, Item_Type)
VALUES
    ('101', 500, 2021, 'Available', 'Book'),
    ('102', 300, 2020, 'Checked Out', 'Magazine'),
    ('103', 150, 2022, 'Reserved', 'DVD');

-- 2. Insert Data into Book Table --

INSERT INTO Book (Item_ID, ISBN, Title, Subject)
VALUES
    ('101', '9780131103627', 'Introduction to Algorithms', 'Computer Science');

-- 3. Insert Data into Magazine Table --

INSERT INTO Magazine (Item_ID, ISSN, Name, Edition, Publish_Date)
VALUES
    ('102', '1234567890123', 'National Geographic', 45, '2020-05-01');

-- 4. Query to Retrieve All Items of Type 'Book' --

SELECT * 
FROM Item
WHERE Item_Type = 'Book';

-- 5. Join Query to Fetch Book Details --

SELECT i.Item_ID, i.Price, i.Year, b.ISBN, b.Title, b.Subject
FROM Item i
JOIN Book b ON i.Item_ID = b.Item_ID;

-- 6. Query to Find Available Items --

SELECT Item_ID, Item_Type, Price, Availability_Status
FROM Item
WHERE Availability_Status = 'Available';

-- 7. Query to Count Items by Type --

SELECT Item_Type, COUNT(*) AS Item_Count
FROM Item
GROUP BY Item_Type;

-- 8. Query to Retrieve Recently Added Magazines --

SELECT m.Name, m.Edition, m.Publish_Date
FROM Magazine m
JOIN Item i ON m.Item_ID = i.Item_ID
WHERE i.Year >= 2020;

-- 9. Update Availability Status --

UPDATE Item
SET Availability_Status = 'Purchased'
WHERE Item_ID = '103';

-- 10. Delete Membership from Users --

DELETE FROM Has_Membership
WHERE User_ID = 100;

-- 11. Query to Retrieve All Books Published After 2015 --

SELECT b.Title, b.ISBN, i.Year
FROM Book b
JOIN Item i ON b.Item_ID = i.Item_ID
WHERE i.Year > 2015;

-- 12. Query to List All Reserved Items --

SELECT Item_ID, Item_Type, Price, Year, Availability_Status
FROM Item
WHERE Availability_Status = 'Reserved';

-- 13. Query to Find the Most Expensive Item --

SELECT Item_ID, Item_Type, Price
FROM Item
ORDER BY Price DESC
LIMIT 1;

-- 14. Query to Count Items Available for Each Year

SELECT Year, COUNT(*) AS Available_Items
FROM Item
WHERE Availability_Status = 'Available'
GROUP BY Year
ORDER BY Year DESC;

-- 15. Query to Retrieve Book Titles and Their Subjects --

SELECT b.Title, b.Subject
FROM Book b;

-- 16. Update the Price of DVDs Released before 2020 --

UPDATE Item
SET Price = Price * .1
WHERE Item_Type = 'DVD' AND Year < 2020;

-- 17. Query to Find All Items with Price Below 200 --

SELECT Item_ID, Item_Type, Price, Year
FROM Item
WHERE Price < 50;

-- 18. Delete All Records of a Specific Magazine --

DELETE FROM Magazine
WHERE Name = 'National Geographic' AND Edition = 45;

-- Testing Unexpected Input and Edge Cases --

-- Test Case 1: Null Values in Non-Nullable Columns --
-- Objective: Ensure NOT NULL constraints are enforced. --

INSERT INTO Item (Item_ID, Price, Year, Availability_Status, Item_Type)
VALUES ('500', NULL, 2023, 'Available', 'Book');

-- Test Case 2: Foreign Key Constraint Violation --
-- Objective: Prevent inserting a Book that refers to a non-existent Item_ID. --

INSERT INTO Book (Item_ID, ISBN, Title, Subject)
VALUES ('I999', '9781234567890', 'Invisible Library', 'Fantasy');

-- Test Case 4: Invalid ENUM Values --
-- Objective: Ensure that invalid ENUM values are rejected. --

INSERT INTO Item (Item_ID, Price, Year, Availability_Status, Item_Type)
VALUES ('500', 500, 2022, 'Lost', 'Book');