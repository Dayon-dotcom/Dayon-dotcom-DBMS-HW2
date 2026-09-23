CREATE DATABASE NEW_COFFEE_SHOP;
USE NEW_COFFEE_SHOP;

CREATE TABLE baristas (
baristasID INT PRIMARY KEY,
name VARCHAR(100),
experience_level VARCHAR(50)
);

CREATE TABLE shops (
shopID INT PRIMARY KEY,
name VARCHAR(100),
city VARCHAR(100)
);

CREATE TABLE pastries (
pastryID INT PRIMARY KEY,
name VARCHAR(100),
categories VARCHAR(50),
price DECIMAL(5,2)
);
CREATE TABLE employs (
baristasID INT,
shopID INT,

PRIMARY KEY (baristaID, shopID),

FOREIGN KEY(baristaID)
REFERENCES baristas (baristaID),

FOREIGN KEY (shopID)
REFERENCES shops(shopID)
);

CREATE TABLE offers (
shopID INT,
pastryID INT,
date_added DATE,

PRIMARY KEY (shopID, pastryID),

FOREIGN KEY(shopID)
REFERENCES shops(shopID),

FOREIGN KEY (pastryID)
REFERENCES pastries(pastryID)
);

-- Q1
-- this is the avg price of pastries
-- barista is the primary
SELECT 
    category, 
    ROUND(AVG(price), 2) AS average_price
FROM pastries
GROUP BY category;

-- Q2
-- the total number of baristas with experience
-- shopID is the primary key
SELECT 
    experience_level, 
    COUNT(*) AS total_baristas
FROM baristas
GROUP BY experience_level;

-- Q3
-- total number of shops
-- pastryID is the Primary Key
SELECT 
    city, 
    COUNT(*) AS total_shops
FROM shops
GROUP BY city;
-- Q4
-- The maximum price in the pastries
SELECT 
    category, 
    MAX(price) AS max_price
FROM pastries
GROUP BY category;
-- Q5
-- the amount of pastries added
SELECT 
    shopID, 
    COUNT(pastryID) AS pastry_count
FROM offers
GROUP BY shopID;
-- Q6
-- Name, category, and price of the pastry
SELECT 
    p.name, 
    p.category, 
    p.price
FROM pastries p
WHERE p.price = (
    SELECT MAX(sub.price)
    FROM pastries sub
    WHERE sub.category = p.category
);
-- Q7
-- The shops ID
SELECT DISTINCT 
    o.shopID
FROM offers o
JOIN pastries p ON o.pastryID = p.pastryID
WHERE p.price > (
    SELECT AVG(price) 
    FROM pastries
);
-- Q8
-- shop id and pastry id
SELECT 
    shopID, 
    pastryID, 
    date_added
FROM offers
WHERE date_added = (
    SELECT MIN(date_added) 
    FROM offers
);
-- Q9
-- the shop ids highest number of patries

SELECT 
    shopID, 
    COUNT(pastryID) AS pastry_count
FROM offers
GROUP BY shopID
HAVING COUNT(pastryID) = (
    SELECT MAX(shop_counts.total)
    FROM (
        SELECT COUNT(pastryID) AS total
        FROM offers
        GROUP BY shopID
    ) AS shop_counts
);
-- Q10
-- finding the names of baristas who work

SELECT name 
FROM baristas
WHERE baristaID IN (
    SELECT baristaID 
    FROM employs
    WHERE shopID IN (
        SELECT shopID 
        FROM shops
        WHERE city = 'Seattle'
    )
);
