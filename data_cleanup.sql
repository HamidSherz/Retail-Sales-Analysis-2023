-- 1. Orders Table: Check for any NULL values in critical fields
-- This query identifies rows in the Orders table where critical identifiers like 
-- Order ID, Customer ID, or Product ID are NULL, which can hinder analysis.
SELECT *
FROM Orders
WHERE `Order ID` IS NULL OR `Customer ID` IS NULL OR `Product ID` IS NULL;

-- 2. Orders Table: Identify duplicate orders based on Order ID
-- This query counts the occurrences of each Order ID. If any Order ID appears 
-- more than once, it indicates duplicates that need to be addressed.
SELECT 
    `Order ID`, 
    COUNT(*) AS duplicate_count
FROM Orders
GROUP BY `Order ID`
HAVING COUNT(*) > 1;

-- 3. Orders Table: Handle duplicates by keeping the first occurrence and deleting the rest
-- This script identifies duplicate orders and retains only the first occurrence,
-- effectively cleaning up the dataset by ensuring each order ID is unique.
DELETE FROM Orders
WHERE `Order ID` IN (
    SELECT `Order ID` FROM (
        SELECT `Order ID` 
        FROM Orders 
        GROUP BY `Order ID` 
        HAVING COUNT(*) > 1
    ) AS duplicates
)
AND `Row ID` NOT IN (
    SELECT MIN(`Row ID`) 
    FROM Orders 
    GROUP BY `Order ID`
);

-- 4. Orders Table: Update NULL Customer IDs with a default value
-- This query replaces any NULL values in the Customer ID column with 'Unknown', 
-- preventing issues in future analyses where customer IDs are required.
UPDATE Orders
SET `Customer ID` = 'Unknown'
WHERE `Customer ID` IS NULL;

-- 5. Orders Table: Update negative Profit and Sales to zero
-- This ensures that negative values in Profit and Sales do not skew analysis,
-- as they may misrepresent performance metrics.
UPDATE Orders
SET `Sales` = 0
WHERE `Sales` < 0;

UPDATE Orders
SET `Profit` = 0
WHERE `Profit` < 0;

-- 6. Orders Table: Clean up spaces and unrecognized characters in Order ID and Customer ID
-- This script removes leading/trailing spaces and any unrecognized characters 
-- from Order IDs and Customer IDs, ensuring consistent formatting.
UPDATE Orders
SET 
    `Order ID` = TRIM(REPLACE(`Order ID`, ' ', '')), 
    `Customer ID` = TRIM(REPLACE(`Customer ID`, ' ', ''))
WHERE `Order ID` LIKE '% %' OR `Customer ID` LIKE '% %';

-- 7. Customers Table: Check for NULL values
-- This query checks the Customers table for NULL values in critical fields 
-- that may impact customer identification.
SELECT *
FROM Customers
WHERE `Customer ID` IS NULL OR `Customer Name` IS NULL;

-- 8. Customers Table: Identify duplicate customers
-- Similar to orders, this identifies duplicates in the Customers table based on 
-- Customer ID to ensure unique customer records.
SELECT 
    `Customer ID`, 
    COUNT(*) AS duplicate_count
FROM Customers
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;

-- 9. Customers Table: Update NULL Customer Names with a default value
-- This replaces any NULL values in the Customer Name column with 'Unknown Customer'
-- to maintain data integrity.
UPDATE Customers
SET `Customer Name` = 'Unknown Customer'
WHERE `Customer Name` IS NULL;

-- 10. Products Table: Check for NULL values
-- This query checks for NULL values in Product ID, Category, or Sub-Category
-- in the Products table, which are crucial for product identification and analysis.
SELECT *
FROM Products
WHERE `Product ID` IS NULL OR `Category` IS NULL OR `Sub-Category` IS NULL;

-- 11. Products Table: Identify duplicate products
-- This identifies duplicate entries in the Products table based on Product ID
-- to ensure data uniqueness.
SELECT 
    `Product ID`, 
    COUNT(*) AS duplicate_count
FROM Products
GROUP BY `Product ID`
HAVING COUNT(*) > 1;

-- 12. Products Table: Update NULL Categories and Sub-Categories
-- This updates any NULL values in Categories or Sub-Categories with 'Miscellaneous',
-- maintaining data quality.
UPDATE Products
SET `Category` = 'Miscellaneous'
WHERE `Category` IS NULL;

UPDATE Products
SET `Sub-Category` = 'Miscellaneous'
WHERE `Sub-Category` IS NULL;

-- 13. Location Table: Check for NULL values
-- This checks for NULL values in the Location table, ensuring all necessary
-- geographic identifiers are present.
SELECT *
FROM Location
WHERE `Postal Code` IS NULL OR `City` IS NULL OR `State` IS NULL;

-- 14. Location Table: Identify duplicate locations
-- This identifies duplicates in the Location table based on Postal Code 
-- for consistent location records.
SELECT 
    `Postal Code`, 
    COUNT(*) AS duplicate_count
FROM Location
GROUP BY `Postal Code`
HAVING COUNT(*) > 1;

-- 15. Location Table: Update NULL Cities and States
-- This updates any NULL values in the City and State columns to 'Unknown City'
-- and 'Unknown State', respectively.
UPDATE Location
SET `City` = 'Unknown City'
WHERE `City` IS NULL;

UPDATE Location
SET `State` = 'Unknown State'
WHERE `State` IS NULL;

-- 16. Location Table: Clean up spaces in Postal Code
-- This script removes leading/trailing spaces from Postal Code entries to ensure 
-- consistent formatting.
UPDATE Location
SET `Postal Code` = TRIM(REPLACE(`Postal Code`, ' ', ''))
WHERE `Postal Code` LIKE '% %';