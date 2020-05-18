USE tiny_houses;
CREATE TABLE `tiny_houses`.`tiny_house_marketplace` (
  `id` INT NOT NULL,
  `title` VARCHAR(100) NULL,
  `bed & bath` VARCHAR(25) NULL,
  `area` VARCHAR(25) NULL,
  `property_type, city & state` VARCHAR(100) NULL,
  `price` VARCHAR(35) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC));

-- read in csv file --
LOAD DATA INFILE 'tiny_house_marketplace.csv'
INTO TABLE `tiny_house_marketplace`
CHARACTER SET latin1
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check for NULL values -- 
SELECT * FROM tiny_house_marketplace WHERE title IS NULL;
SELECT * FROM tiny_house_marketplace WHERE `bed & bath` IS NULL;
SELECT * FROM tiny_house_marketplace WHERE area IS NULL;
SELECT * FROM tiny_house_marketplace WHERE `property_type, city & state` IS NULL;
SELECT * FROM tiny_house_marketplace WHERE price IS NULL;

-- adding a bedrooms and bathrooms column --
ALTER TABLE tiny_house_marketplace
ADD bedrooms VARCHAR(15) AFTER title;
ALTER TABLE tiny_house_marketplace
ADD bathrooms VARCHAR(15) AFTER bedrooms;
-- splitting bed & bath column --
UPDATE tiny_house_marketplace
SET 
bedrooms = SUBSTRING_INDEX(`bed & bath`, ',', 1),
bathrooms = SUBSTRING_INDEX(`bed & bath`, ',', -1);
-- changing the property_type column --
ALTER TABLE tiny_house_marketplace
CHANGE `property_type` `property_type, city & state` VARCHAR(150);

