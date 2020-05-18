-- How many tiny house listings feature movable homes? --
CREATE TABLE mobile
SELECT * FROM tiny_houses_all WHERE 
 property_type='Tiny House Trailer' OR property_type='Tiny House on a Trailer' OR
 property_type='Tiny House Shell on a Trailer' OR property_type='Converted Vehicle' OR
 property_type='rv' OR property_type='tiny_house_trailer' OR 
 property_type='converted_bus' OR property_type='camper';
-- Add mobility column and set value to 'mobile' --
ALTER TABLE mobile ADD COLUMN mobility VARCHAR(15);
UPDATE mobile SET mobility = 'mobile';
 -- Display mobile table --
SELECT * FROM mobile;

-- How many tiny house listings feature non-mobile homes? --
CREATE TABLE non_mobile
SELECT * FROM tiny_houses_all WHERE 
property_type='Container Home' OR property_type='Tiny House Shell on a Foundation' OR
property_type='Tiny House on a Foundation' OR property_type='cabin' OR
property_type='park_model' OR property_type='container_home' OR
property_type='tiny_house' OR property_type='tiny_house_shell';
-- Add mobility column and set value to 'non_mobile' --
ALTER TABLE non_mobile ADD COLUMN mobility VARCHAR(15);
UPDATE non_mobile SET mobility = 'non_mobile';
 -- Display non_mobile table --
SELECT * FROM non_mobile;
 -- Create a table from the union of the two tables --
CREATE TABLE tiny_house_mobility AS
SELECT * FROM mobile UNION ALL SELECT * FROM non_mobile;
SELECT * FROM tiny_house_mobility;
-- show average price per state in mobile & non_mobile categories --
SELECT state, avg(price), mobility
FROM (SELECT * FROM mobile UNION ALL SELECT * FROM non_mobile) AS all_
GROUP BY state, mobility;

 -- Pivot the tables to show average price per state in mobile & non_mobile categories --
SELECT state,
 AVG(CASE WHEN mobility = 'mobile' THEN price ELSE NULL END) AS mobile,
 AVG(CASE WHEN mobility = 'non_mobile' THEN price ELSE NULL END) AS non_mobile
 FROM (SELECT *
FROM (SELECT * FROM mobile UNION ALL SELECT * FROM non_mobile) AS all_) AS price
GROUP BY state;

SELECT 
(SELECT COUNT(id) 
 FROM tiny_house_mobility
 WHERE mobility = 'mobile') AS mobile,
(SELECT COUNT(id) 
 FROM tiny_house_mobility
 WHERE mobility = 'non_mobile') AS non_mobile
 FROM tiny_house_mobility

 -- Pivot the tables to show count per state in mobile & non_mobile categories --
SELECT state,
 COUNT(CASE WHEN mobility = 'mobile' THEN id ELSE NULL END) AS mobile,
 COUNT(CASE WHEN mobility = 'non_mobile' THEN id ELSE NULL END) AS non_mobile
 FROM (SELECT mobility, id, state
FROM (SELECT * FROM mobile UNION ALL SELECT * FROM non_mobile) AS all_) AS price
GROUP BY state;