USE BookStore;

-- Find books that contain the article "The" in the title and were published after 2000

SELECT 
	Title
FROM
	Books
WHERE
	Title LIKE '%The%'
	AND PublishedDate > CAST ('2000-01-01' AS DATE);

-- Find the cheapest book that was published after 2000

SELECT
	TOP 1 
	b.Title, 
	b.PublishedDate, 
	s.PricePerBook
FROM
	Books b
INNER JOIN Sales s
ON
	b.BookId = s.BookId
WHERE 
	PublishedDate > CAST('2000-01-01' AS DATE)
ORDER BY 
	PricePerBook ASC;

-- In which language the books published have more sales and what is the average price of a book in terms of languages of publication

SELECT 
	b.BookId,
	b.PublishedLanguage,
	s.QuantityOfSold,
	AVG(PricePerBook) OVER(PARTITION BY PublishedLanguage) AS AveragePrice
FROM
	Books b
INNER JOIN Sales s
ON
	b.BookId = s.BookId
ORDER BY
	s.QuantityOfSold DESC;

-- Find the top 5 books by income, what income they brought to the bookstore during this period of time and their rating

SELECT
	TOP 5
	b.Title,
	s.PricePerBook * s.QuantityOfSold as BookRevenue,
	r.Stars
FROM 
	Books b
INNER JOIN 
	Sales s 
ON
	b.BookId = s.BookId
INNER JOIN 
	Reviews r 
ON
	b.BookId = r.BookId
ORDER BY
	BookRevenue DESC;

-- The position of the author in the list of authors, the title of the book and the names of the authors

WITH PositionDisplayName AS (
SELECT
	AuthorId,
	BookId,
		CASE
		AuthorPosition
		WHEN 1 THEN 'first author'
		WHEN 2 THEN 'second author'
		ELSE 'author'
	END AS AuthorPosition
FROM
	BookAuthors
)

SELECT
	p.AuthorPosition,
	b.Title,
	CONCAT(a.FirstName, ' ', a.LastName) AS FullName
FROM
	Books b
INNER JOIN PositionDisplayName p
ON
	p.BookId = b.BookId
INNER JOIN Authors a 
ON
	p.AuthorId = a.AuthorId;

-- Create a table for one chosen BookId of the book with 2 columns, where we will see the stars, ISBN, publishing language and payment method

DECLARE @BookId INT = 100

SELECT
	b.Isbn AS 'Rating and ISBN',
	s.PaymentMethod AS 'Language and Payment'
FROM
	Books b
INNER JOIN Sales s 
ON
	b.BookId = s.BookId
WHERE
	b.BookId = @BookId
	
UNION 

SELECT
	r.Stars AS 'Rating and ISBN',
	b.PublishedLanguage AS 'Language and Payment'
FROM
	Reviews r
INNER JOIN Books b 
ON
	r.BookId = b.BookId
WHERE
	b.BookId = @BookId;

-- The maximum and minimum price of the book

SELECT
	'the cheapest book' AS parametr,
	MIN(PricePerBook) AS value
FROM
	Sales s
UNION

SELECT
	'the most expensive book' AS parametr,
	MAX(PricePerBook) AS value
FROM
	Sales s;

-- Find books, the income from which is higher than the average

SELECT 
	b.Title,
	s.PricePerBook * s.QuantityOfSold as Revenue
FROM
	Sales s
INNER JOIN Books b 
ON
	s.BookId = b.BookId
WHERE
	s.PricePerBook * s.QuantityOfSold > (
	SELECT
		AVG(s.PricePerBook * s.QuantityOfSold) AS AvgRevenue
	FROM
		Sales s
);

-- Find unique authors, the total number of pages in the books they have published and their emails

SELECT
	DistinctAuthors.AuthorId,
	DistinctAuthors.SumOfPages,
	a.Email
FROM
	(
	SELECT
		AuthorId,
		SUM(b.TotalPages) AS SumOfPages
	FROM
		BookAuthors ba
	INNER JOIN Books b 
	ON
		ba.BookId = b.BookId
	GROUP BY
		AuthorId
) AS DistinctAuthors
INNER JOIN Authors a 
ON
	DistinctAuthors.AuthorId = a.AuthorId;

-- The name, rating and income of the book that has more than two authors.

SELECT 
	b.Title,
	COUNT(a.AuthorId) AS NumberOfAuthors,
	r.Stars,
	(s.PricePerBook * s.QuantityOfSold) as Revenue
FROM
	Books b
INNER JOIN BookAuthors ba 
ON
	b.BookId = ba.BookId
INNER JOIN Authors a 
ON
	ba.AuthorId = a.AuthorId
INNER JOIN Reviews r 
ON
	b.BookId = r.BookId
INNER JOIN Sales s 
ON
	b.BookId = s.BookId
GROUP BY
	b.Title,
	r.Stars,
	s.PricePerBook * s.QuantityOfSold
HAVING
	COUNT(DISTINCT a.AuthorId) > 1;

-- The same with using CTE

WITH TwoAuthors AS (
SELECT
	b.Bookid,
	b.Title,
	COUNT(DISTINCT a.AuthorId) AS NumberOfAuthors
FROM
	books b
INNER JOIN BookAuthors ba
ON
	b.BookId = ba.BookId
INNER JOIN authors a
ON
	ba.AuthorId = a.AuthorId
GROUP BY
	b.Title,
	b.BookId
HAVING
	COUNT(DISTINCT a.AuthorId) > 1)
	
	
SELECT 
	t.Title, 
	t.NumberOfAuthors,
	r.Stars,
	(s.PricePerBook * s.QuantityOfSold) AS Revenue
FROM
	TwoAuthors t
INNER JOIN Reviews r
ON
	t.BookId = r.BookId
INNER JOIN Sales s
ON
	t.BookId = s.BookId;