
-- Creating database BookStore with tables Authors and Books


CREATE DATABASE BookStore;

	
CREATE TABLE Authors (
	AuthorId INT IDENTITY(1,1),
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Email VARCHAR(100) NOT NULL,
	PRIMARY KEY(AuthorId)
);




CREATE TABLE Books (
	BookId  INT IDENTITY(100, 1),
	Isbn BIGINT NOT NULL,
	Title VARCHAR(250) NOT NULL,
	PublishedDate DATE NOT NULL,
	PublishedLanguage VARCHAR(100) NOT NULL,
	TotalPages INT NOT NULL CHECK (TotalPages>100),
	PRIMARY KEY(BookId)
);


--We've got many to many relationships in the previous 2 tables. 
--Regarding normalization, I created a table named BookAuthors with a combination of AuthorId and BooKId as Primary Key.


CREATE TABLE BookAuthors (
	AuthorId INT NOT NULL,
	BookId INT NOT NULL,
	AuthorPosition INT NOT NULL,
	PRIMARY KEY(BookId, AuthorId), 
	FOREIGN KEY(AuthorId) REFERENCES Authors(AuthorId),
	FOREIGN KEY(BookId) REFERENCES Books(BookId)
);


-- We need 2 more tables: Reviews and Sales. In the Sales table, we have got a column with default values.


CREATE TABLE Reviews (
	ReviewId INT IDENTITY(200, 1),
	BookId INT NOT NULL,
	Stars DECIMAL(2,1) NOT NULL,
	PRIMARY KEY(ReviewId),
	FOREIGN KEY(BookId) REFERENCES Books(BookId)
);


--In the Sales table, we have a column with default values. Results aggregation by a week.


CREATE TABLE Sales (
	SaleId INT IDENTITY(300, 1),
	BookId INT NOT NULL,
	PricePerBook DECIMAL(5,2) NOT NULL,
	QuantityOfSold INT NOT NULL, 
	PaymentMethod VARCHAR(50) DEFAULT 'Debit card',
	PRIMARY KEY(SaleId),
	FOREIGN KEY(BookId) REFERENCES Books(BookId)
);

-- Inserting values to all 5 tables.

INSERT INTO 
	Authors(FirstName, LastName, Email)
VALUES 
	('Joanne', 'Rowling', 'jkrowling@mail.com'),
	('Jane', 'Austen', 'janeausten@mail.com'),
	('Charlotte', 'Brontë', 'charlottebronte@mail.com'),
	('Mark', 'Twain', 'marktwain@mail.com'),
	('John', 'Tolkien', 'jrrtolkien@mail.com'),
	('Clive', 'Lewis', 'cslewis@mail.com'),
	('Liz', 'Fenton', 'fenton@mail.com'),
	('Lisa', 'Steinke', 'steinke@mail.com');

SELECT * 
FROM Authors;


INSERT INTO 
	Books (Isbn, Title, PublishedDate, PublishedLanguage, TotalPages) 
VALUES 
	(9780439362139, 'Harry Potter and the Sorcerers Stone', '2001-01-01', 'English', 300),
	(9780141439518, 'Pride and Prejudice', '1813-01-28', 'English', 250),
	(9781840227925, 'Jane Eyre', '1847-10-16', 'Ukranian', 400),
	(9781435163669, 'The Adventures of Tom Sawyer', '1876-01-01', 'Ukranian', 200),
	(9780261103252, 'The Lord of the Rings', '1954-07-29', 'English', 1000),
	(9780007528097, 'The Chronicles of Narnia', '1950-10-16', 'Ukranian', 700),
	(9781542005098, 'How to Save a Life', '2020-02-05', 'Ukranian', 280),
	(9780751552867, 'The Casual Vacancy', '2013-07-09', 'English', 576);


SELECT * 
FROM Books;

INSERT INTO 
	BookAuthors (AuthorId, BookId, AuthorPosition)
VALUES 
	(1, 100, 1),
	(2, 101, 1),
	(3, 102, 1),
	(4, 103, 1),
	(5, 104, 1),
	(6, 105, 1),
	(7, 106, 1),
	(8, 106, 2),
	(1, 107, 1);


SELECT * 
FROM BookAuthors;

INSERT INTO 
	Reviews (BookId, Stars) 
VALUES 
	(100, 4.47),
	(101, 4.28),
	(102, 4.15),
	(103, 3.92),
	(104, 4.29),
	(105, 4.23),
	(106, 3.88),
	(107, 3.30);

SELECT * 
FROM Reviews;


INSERT INTO 
	Sales (BookId, PricePerBook, QuantityOfSold) 
VALUES 
	(100, 20.5, 24),
	(101, 15.4, 22),
	(102, 28.9, 13),
	(103, 19.2, 13),
	(104, 21.9, 26),
	(105, 14.9, 30),
	(106, 35.1, 11),
	(107, 40.8, 9);

SELECT * 
FROM Sales;

