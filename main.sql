CREATE TABLE Item (
    Item_ID CHAR(10) PRIMARY KEY,
    Price INT not null,
    Year NUMERIC(4, 0),
    Availability_Status ENUM('Available', 'Checked Out', 'Reserved', 'Purchased') NOT NULL,
    Item_Type ENUM('Book', 'Digital Media', 'Magazine', 'DVD', 'Music') NOT NULL
);

CREATE TABLE Book (
    Item_ID CHAR(10) PRIMARY KEY,
    ISBN VARCHAR(13),
    Title VARCHAR(50),
    Subject VARCHAR(20),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE TABLE Magazine (
    Item_ID CHAR(10) PRIMARY KEY,
    ISSN VARCHAR(13),
    Name VARCHAR(50),
    Edition INT,
    Publish_Date CHAR(10),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE TABLE Digital_Media (
    Item_ID CHAR(10) PRIMARY KEY,
    DOI INT,
    Media_Type VARCHAR(15),
    Release_Date CHAR(10),
    Title CHAR(10),
    Creator CHAR(20),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE TABLE DVD (
    Item_ID CHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Director VARCHAR(20),
    Duration TIME,
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE TABLE Music (
    Item_Id CHAR(10) PRIMARY KEY,
    Title CHAR(20),
    Artist VARCHAR(50),
    Album VARCHAR(50),
    Format ENUM('CD', 'Vinyl', 'Digital'),
    FOREIGN KEY (Item_Id) REFERENCES Item(Item_ID)
);

CREATE TABLE User (
    User_ID CHAR(10) PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Address VARCHAR(30),
    Email VARCHAR(20),
    Phone_Number CHAR(12)
);

CREATE TABLE Membership (
    Membership_Type CHAR(10) PRIMARY KEY,
    Borrow_Limit INT NOT NULL,
    Membership_Fee DECIMAL(3, 2) NOT NULL,
    Discount_Rate DECIMAL(2, 2) NOT NULL
);

CREATE TABLE Member (
    User_ID CHAR(10) PRIMARY KEY,
    Card_Number INT NOT NULL,
    Current_Borrows INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Membership_Type) REFERENCES Membership(Membership_Type)
);

CREATE TABLE Staff (
    User_ID CHAR(10) PRIMARY KEY,
    Position VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Transaction (
    Transaction_ID CHAR(10) PRIMARY KEY,
    Transaction_Date DATE NOT NULL,
    Status ENUM('Completed', 'Pending', 'Canceled') NOT NULL,
    User_ID CHAR(10) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Purchase (
    Transaction_ID CHAR(10) PRIMARY KEY,
    Purchase_Amount DECIMAL(10, 2) NOT NULL,
    Purchase_Type VARCHAR(10),
    Payment_Method ENUM('Credit Card', 'Debit Card', 'Cash', 'Other') NOT NULL,
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID)
);

CREATE TABLE Borrow (
    Transaction_ID CHAR(10) PRIMARY KEY,
    Borrow_Date DATE NOT NULL,
    Due_Date DATE,
    Return_Date DATE,
    Late_Fee DECIMAL(5, 2),
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID)
);

CREATE TABLE Author (
    Author_ID CHAR(10) PRIMARY KEY,
    Name VARCHAR(20) NOT NULL,
    Biography CLOB,
    Date_of_Birth DATE,
    Date_of_Death DATE
);

CREATE TABLE Genre (
    Genre_Name VARCHAR(20) PRIMARY KEY,
    Description VARCHAR(255),
    Location_in_Library INT
);

CREATE TABLE Publisher (
    Publisher_ID CHAR(10) PRIMARY KEY,
    Name Varchar(20) NOT NULL,
    Address VARCHAR(30),
    Phone CHAR(12),
    Email VARCHAR(20)
);

-- Relationship Tables --

CREATE TABLE Transaction_Involves_Item (
    Transaction_ID CHAR(10) PRIMARY KEY,
    Item_ID CHAR(10) PRIMARY KEY,
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    PRIMARY KEY (Transaction_ID, Item_ID)
);

CREATE TABLE Author_Writes_Item (
    Author_ID CHAR(10),
    Item_ID CHAR(10),
    FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    PRIMARY KEY (Author_ID, Item_ID)
);

CREATE TABLE Has_Membership (
    User_ID CHAR(10) PRIMARY KEY,
    Membership_Type CHAR(10),
    PRIMARY KEY (User_ID),
    FOREIGN KEY (User_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Membership_Type) REFERENCES Membership(Membership_Type)
);

CREATE TABLE Membership_Transaction (
    Transaction_ID CHAR(10),
    Membership_Type CHAR(10),
    PRIMARY KEY (Transaction_ID),
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID),
    FOREIGN KEY (Membership_Type) REFERENCES Membership(Membership_Type)
);

CREATE TABLE Publishes (
    Publisher_ID CHAR(10),
    Item_ID CHAR(10),
    PRIMARY KEY (Item_ID),
    FOREIGN KEY (Publisher_ID) REFERENCES Publisher(Publisher_ID),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID)
);

CREATE TABLE Belongs (
    Item_ID CHAR(10),
    Genre_Name VARCHAR(20),
    PRIMARY KEY (Item_ID),
    FOREIGN KEY (Item_ID) REFERENCES Item(Item_ID),
    FOREIGN KEY (Genre_Name) REFERENCES Genre(Genre_Name)
);

CREATE TABLE Performs (
    User_ID CHAR(10),
    Transaction_ID CHAR(10),
    PRIMARY KEY (Transaction_ID),
    FOREIGN KEY (User_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction(Transaction_ID)
);