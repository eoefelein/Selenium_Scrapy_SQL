-- connect to database --
USE tiny_houses;
-- display secure file location --
SHOW VARIABLES LIKE "secure_file_priv";

-- create tiny_house_listings table --
CREATE TABLE `tiny_houses`.`tiny_house_marketplace` (
  `id` INT NOT NULL,
  `slug` VARCHAR(100) NULL,
  `title` VARCHAR(100) NULL,
  `property_type` VARCHAR(50) NULL,
  `purchase_type` VARCHAR(50) NULL,
  `bedrooms` VARCHAR(25) NULL,
  `bathrooms` VARCHAR(25) NULL,
  `area` VARCHAR(25) NULL,
  `city` VARCHAR(50) NULL,
  `state` VARCHAR(25) NULL,
  `photo_url` VARCHAR(100) NULL,
  `lister` VARCHAR(100) NULL,
  `lat` INT NOT NULL,
  `lng` INT NOT NULL,
  `default_price` VARCHAR(35) NOT NULL,
  `created_at` TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC));

-- drop table index --
ALTER TABLE `tiny_houses`.`tiny_house_listings` 
DROP INDEX `title_UNIQUE`;
-- enable table changes --
SET SQL_SAFE_UPDATES = 0;
-- drop photo_public_id column from tiny_house_listings table --
ALTER TABLE `tiny_houses`.`tiny_house_listings` 
DROP COLUMN `photo_public_id`;

-- read in csv file --
LOAD DATA INFILE 'tiny_house_listings.csv' 
INTO TABLE `tiny_house_listings` 
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- clean the columns --
UPDATE tiny_house_listings
SET lister = TRIM(', \'first_name\'' FROM lister);
UPDATE tiny_house_listings
SET default_price = TRIM(', \'amount_curren' FROM default_price);
UPDATE tiny_house_listings
SET default_price = TRIM(', \'amount_currenc' FROM default_price);
UPDATE tiny_house_listings
SET default_price = TRIM(', \'amount_currency' FROM default_price);
UPDATE tiny_house_listings
SET state = TRIM('\'' FROM state);

-- check for NULL values -- 
SELECT * FROM tiny_house_listings WHERE title IS NULL;
SELECT * FROM tiny_house_listings WHERE property_type IS NULL;
SELECT * FROM tiny_house_listings WHERE purchase_type IS NULL;
SELECT * FROM tiny_house_listings WHERE bedrooms IS NULL;
SELECT * FROM tiny_house_listings WHERE bathrooms IS NULL;
SELECT * FROM tiny_house_listings WHERE area IS NULL;
SELECT * FROM tiny_house_listings WHERE default_price IS NULL;

-- Initial Exploratory Data Analysis --
-- What is most common property_type? --
SELECT property_type, count(*) AS count
  FROM tiny_house_listings
 GROUP BY property_type
 ORDER BY count DESC;
-- What is the average price per state? --
SELECT avg(price) AS avg_price, state 
FROM tiny_house_listings 
GROUP BY state 
ORDER BY avg_price DESC;
-- What is the average price per number of bedrooms? --
SELECT 
bedrooms,
avg(price)
FROM tiny_house_listings
GROUP BY bedrooms;


