-- create temporary table listings --
CREATE TEMPORARY TABLE listings
SELECT id, title, property_type, bedrooms, bathrooms, area, city, state, price
FROM tiny_house_listings;
-- create temporary table marketplace --
CREATE TEMPORARY TABLE marketplace
SELECT * FROM tiny_house_marketplace;
-- Union the TEMP tables --
SELECT * FROM marketplace UNION ALL SELECT * FROM listings AS all_house_listings;

-- Initial Exploratory Data Analysis --
-- How many tiny house listings are there per state? --
SELECT state, count(*)
FROM (SELECT * FROM marketplace UNION ALL SELECT * FROM listings) AS all_house_listings
GROUP BY state;

-- More complex window functions warrant the creation of a permanent table here --
CREATE TABLE tiny_houses_all AS
SELECT *
FROM tiny_house_marketplace
UNION ALL
SELECT id, title, property_type, bedrooms, bathrooms, area, city, state, price
FROM tiny_house_listings;

-- ensure columns are of the proper data type --
ALTER TABLE tiny_houses_all MODIFY price INTEGER;
-- What is the price per sq. ft. of each home? --
ALTER TABLE tiny_houses_all ADD COLUMN price_per_sq_ft INT;
UPDATE tiny_houses_all
SET price_per_sq_ft = (price/area);
-- How many tiny house listings are there? Summary statistics provided, excluding outliers --
SELECT 
count(id) AS tiny_house_total,
min(price_per_sq_ft) AS min_price,
avg(price_per_sq_ft) AS avg_price,
max(price_per_sq_ft) AS max_price
FROM (SELECT * FROM tiny_houses_all WHERE price < 1000000) AS outliers;

-- clean the bathrooms column -- 
UPDATE tiny_houses_all 
SET bathrooms = REPLACE(`bathrooms`, 'baths', '');
UPDATE tiny_houses_all
SET bathrooms = REPLACE(`bathrooms`, 'bath', '');

-- Display the distinct State types --
SELECT COUNT(DISTINCT(State)) FROM tiny_houses_all;
ALTER TABLE tiny_houses_all CHANGE `State` `state` VARCHAR(45);
UPDATE tiny_houses_all 
SET State = TRIM(State);

-- cleaning the columns --
UPDATE tiny_houses_all 
SET State ='Tennessee'
WHERE id='637';
SELECT * FROM tiny_houses_all WHERE city='Nashville';

DELETE FROM tiny_houses_all WHERE State='British Columbia';
DELETE FROM tiny_houses_all WHERE State='1 bath';
DELETE FROM tiny_houses_all WHERE State=' British Columb';
DELETE FROM tiny_houses_all WHERE State=' Berlin';
DELETE FROM tiny_houses_all WHERE State='BC';
DELETE FROM tiny_houses_all WHERE State='B.C.';
DELETE FROM tiny_houses_all WHERE State=' VÃ¤stra GÃ¶tal';
DELETE FROM tiny_houses_all WHERE State=' Bucuresti';
DELETE FROM tiny_houses_all WHERE State=' Sofia';
DELETE FROM tiny_houses_all WHERE State='New South Wales';
DELETE FROM tiny_houses_all WHERE State='Quebec';
DELETE FROM tiny_houses_all WHERE State='Alabamaberta';
DELETE FROM tiny_houses_all WHERE State='Queensland';
DELETE FROM tiny_houses_all WHERE State='Bihor';
DELETE FROM tiny_houses_all WHERE State='Newfoundland and Labrador';
DELETE FROM tiny_houses_all WHERE State=' Leicestershire';
DELETE FROM tiny_houses_all WHERE State=' Alabamaberta';
DELETE FROM tiny_houses_all WHERE State='England and Wales';
DELETE FROM tiny_houses_all WHERE State='Victoria';
DELETE FROM tiny_houses_all WHERE State='Manitoba';
DELETE FROM tiny_houses_all WHERE State='Panama';
DELETE FROM tiny_houses_all WHERE State='ON';
DELETE FROM tiny_houses_all WHERE State='Ontario';
DELETE FROM tiny_houses_all WHERE State='Oxfordshire';
DELETE FROM tiny_houses_all WHERE State='Slovensko';
DELETE FROM tiny_houses_all WHERE State='Midi-PyrÃ©nÃ©e';
DELETE FROM tiny_houses_all WHERE State='Western Austra';
DELETE FROM tiny_houses_all WHERE State='Shanghai';
DELETE FROM tiny_houses_all WHERE State='Vanua Levu';
DELETE FROM tiny_houses_all WHERE State='Puntarenas';
DELETE FROM tiny_houses_all WHERE State='Vanua Levu Isl';
DELETE FROM tiny_houses_all WHERE State='Californiayo District';
DELETE FROM tiny_houses_all WHERE State='ULSTER';
DELETE FROM tiny_houses_all WHERE State='Queensland';
DELETE FROM tiny_houses_all WHERE State='SoUtahh Australia';
DELETE FROM tiny_houses_all WHERE State='vanu leavu isl';
DELETE FROM tiny_houses_all WHERE State='shandong';
DELETE FROM tiny_houses_all WHERE State='Yukon Territory';
DELETE FROM tiny_houses_all WHERE State='Northwest Territories';
DELETE FROM tiny_houses_all WHERE State='WisconsinSouth CarolinaoloradoNSIndi';

SET SQL_SAFE_UPDATES = 0;

update tiny_houses_all set State = replace(State,'AL','Alabama');
update tiny_houses_all set State = replace(State,'ALouisianabama','Alabama');
update tiny_houses_all set State = replace(State,'Al','Alabama');
update tiny_houses_all set State = replace(State,' Alabamaabama','Alabama');
update tiny_houses_all set State = replace(State,'AK','Alaska');
update tiny_houses_all set State = replace(State,'Alabamaaska', 'Alaska');
update tiny_houses_all set State = replace(State,'AZ','Arizona');
update tiny_houses_all set State = replace(State,'Az','Arizona');
update tiny_houses_all set State = replace(State,' 87104','Arizona');
update tiny_houses_all set State = replace(State,' Arizona - ArkansasIZONA','Arizona');
update tiny_houses_all set State = replace(State,'AR','Arkansas');
update tiny_houses_all set State = replace(State,'CA','California');
update tiny_houses_all set State = replace(State,'ca','California');
update tiny_houses_all set State = replace(State,'Californialifornia', 'California');
update tiny_houses_all set State = replace(State,'Ca','California');
update tiny_houses_all set State = replace(State,'Californialfornia','California');
update tiny_houses_all set State = replace(State,'CaliforniaLouisianabamaIFOregonNIowa','California');
update tiny_houses_all set State = replace(State,'CO','Colorado');
update tiny_houses_all set State = replace(State,'CT','Connecticut');
update tiny_houses_all set State = replace(State,'ConnecticUtah','Connecticut');
update tiny_houses_all set State = replace(State,'DC','Washington DC');
update tiny_houses_all set State = replace(State,'DE','Delaware');
update tiny_houses_all set State = replace(State,'DeLouisianaware','Delaware');
update tiny_houses_all set State = replace(State,'DelaWashingtonre','Delaware');
update tiny_houses_all set State = replace(State,'FL','Florida');
update tiny_houses_all set State = replace(State,'Fl','Florida');
update tiny_houses_all set State = replace(State,'Floridaorida','Florida');
update tiny_houses_all set State = replace(State,'FloridaOregonIdahoA (Florida)','Florida');
update tiny_houses_all set State = replace(State,'GA','Georgia');
update tiny_houses_all set State = replace(State,'Ga.','Georgia');
update tiny_houses_all set State = replace(State,'Ga','Georgia');
update tiny_houses_all set State = replace(State,'ga','Georgia');
update tiny_houses_all set State = replace(State,'HI','Hawaii');
update tiny_houses_all set State = replace(State,'HaWashingtonii/Kauai','Hawaii');
update tiny_houses_all set State = replace(State,'HaWashingtonii','Hawaii');
update tiny_houses_all set State = replace(State,'IA','Iowa');
update tiny_houses_all set State = replace(State,'ID','Idaho');
update tiny_houses_all set State = replace(State,'IL','Illinois');
update tiny_houses_all set State = replace(State,'Ill','Illinois');
update tiny_houses_all set State = replace(State,'Illinoisinois','Illinois');
update tiny_houses_all set State = replace(State,'IN','Indiana');
update tiny_houses_all set State = replace(State,'KS','Kansas');
update tiny_houses_all set State = replace(State,'KY','Kentucky');
update tiny_houses_all set state = replace(state,'Ketucky','Kentucky');
update tiny_houses_all set State = replace(State,'Ky','Kentucky');
update tiny_houses_all set State = replace(State,'LA','Louisiana');
update tiny_houses_all set State = replace(State,'la','Louisiana');
update tiny_houses_all set State = replace(State,'MA','Massachusetts');
update tiny_houses_all set State = replace(State,'Mass','Massachusetts');
update tiny_houses_all set State = replace(State,'mass','Massachusetts');
update tiny_houses_all set State = replace(State,'Massachusettsachusetts','Massachusetts');
update tiny_houses_all set State = replace(State,' massachusetts','Massachusetts');
update tiny_houses_all set State = replace(State,'MD','Maryland');
update tiny_houses_all set State = replace(State,'MaryLouisianand','Maryland');
update tiny_houses_all set State = replace(State,'ME','Maine');
update tiny_houses_all set State = replace(State,'Me','Maine');
update tiny_houses_all set State = replace(State,'MI','Michigan');
update tiny_houses_all set State = replace(State,'MichiGeorgian','Michigan');
update tiny_houses_all set State = replace(State,'MN','Minnesota');
update tiny_houses_all set State = replace(State,'MO','Missouri');
update tiny_houses_all set State = replace(State,'MS','Mississippi');
update tiny_houses_all set State = replace(State,'ms','Mississippi');
update tiny_houses_all set State = replace(State,'Ms','Mississippi');
update tiny_houses_all set State = replace(State,'MT','Montana');
update tiny_houses_all set State = replace(State,'MT','montana');
update tiny_houses_all set State = replace(State,'NC','North Carolina');
update tiny_houses_all set State = replace(State,' North Californiarolina', 'North Carolina');
update tiny_houses_all set State = replace(State,'ND','North Dakota');
update tiny_houses_all set State = replace(State,'NE','Nebraska');
update tiny_houses_all set State = replace(State,'NH','New Hampshire');
update tiny_houses_all set State = replace(State,'NJ','New Jersey');
update tiny_houses_all set State = replace(State,'nj','New Jersey');
update tiny_houses_all set State = replace(State,'NM','New Mexico');
update tiny_houses_all set State = replace(State,'New Mainexico','New Mexico');
update tiny_houses_all set State = replace(State,'NV','Nevada');
update tiny_houses_all set State = replace(State,'NY','New York');
update tiny_houses_all set State = replace(State,'new york','New York');
update tiny_houses_all set State = replace(State,'Ny','New York');
update tiny_houses_all set State = replace(State,'ny','New York');
update tiny_houses_all set State = replace(State,'OH','Ohio');
update tiny_houses_all set State = replace(State,'OK','Oklahoma');
update tiny_houses_all set State = replace(State,'OkLouisianahoma','Oklahoma');
update tiny_houses_all set State = replace(State,' Ok','Oklahoma');
update tiny_houses_all set State = replace(State,'OkLouisianahoma','Oklahoma');
update tiny_houses_all set State = replace(State,'OR','Oregon');
update tiny_houses_all set State = replace(State,'Or','Oregon');
update tiny_houses_all set State = replace(State,'PA','Pennsylvania');
update tiny_houses_all set State = replace(State,'Pa','Pennsylvania');
update tiny_houses_all set State = replace(State,'Pennsylvania (','Pennsylvania');
update tiny_houses_all set State = replace(State,'Pennsylvania - Pennsylva','Pennsylvania');
update tiny_houses_all set State = replace(State,'PR','Puerto Rico');
update tiny_houses_all set State = replace(State,'RI','Rhode Island');
update tiny_houses_all set State = replace(State,'SC','South Carolina');
update tiny_houses_all set State = replace(State,' Sc','South Carolina');
update tiny_houses_all set State = replace(State,'SoUtahh Carolina','South Carolina');
update tiny_houses_all set State = replace(State,' South Californiarolina','South Carolina');
update tiny_houses_all set State = replace(State,'SD','South Dakota');
update tiny_houses_all set State = replace(State,'SoUtahh Dakota','South Dakota');
update tiny_houses_all set State = replace(State,'TN','Tennessee');
update tiny_houses_all set State = replace(State,'Tn','Tennessee');
update tiny_houses_all set State = replace(State,'Tennesee','Tennessee');
update tiny_houses_all set State = replace(State,'Tennessse','Tennessee');
update tiny_houses_all set State = replace(State,'TX','Texas');
update tiny_houses_all set State = replace(State,'tx','Texas');
update tiny_houses_all set State = replace(State,'Tx','Texas');
update tiny_houses_all set State = replace(State,' Texas - Texas', 'Texas');
update tiny_houses_all set State = replace(State,'UT','Utah');
update tiny_houses_all set State = replace(State,'ut','Utah');
update tiny_houses_all set State = replace(State,'VA','Virginia');
update tiny_houses_all set State = replace(State,'Va','Virginia');
update tiny_houses_all set State = replace(State,'VT','Vermont');
update tiny_houses_all set State = replace(State,'WA','Washington');
update tiny_houses_all set State = replace(State,'Wa','Washington');
update tiny_houses_all set State = replace(State,'wa','Washington');
update tiny_houses_all set State = replace(State,'Washingtonshington','Washington');
update tiny_houses_all set State = replace(State,'WI','Wisconsin');
update tiny_houses_all set State = replace(State,'Wi','Wisconsin');
update tiny_houses_all set State = replace(State,'Wisconsinsconsin','Wisconsin');
update tiny_houses_all set State = replace(State,'WV','West Virginia');
update tiny_houses_all set State = replace(State,'WY','Wyoming');
update tiny_houses_all set State = replace(State,'Oregonegon','Oregon');
update tiny_houses_all set State = replace(State,'North Californiarolina','North Carolina');
update tiny_houses_all set State = replace(State,'South Californiarolina','South Carolina');
update tiny_houses_all set State = replace(State,'Alabamaabama', 'Alabama');
update tiny_houses_all set State = replace(State,' Floridaorida','Florida');
update tiny_houses_all set State = replace(State,'Oklahomalahoma', 'Oklahoma');
update tiny_houses_all set State = replace(State,'ALouisianaska','Alaska');
update tiny_houses_all set State = replace(State,'IoWashington', 'Iowa');
update tiny_houses_all set State = replace(State,'new haMississippihire', 'New Hampshire');
update tiny_houses_all set State = replace(State,'Georgia (Georgia)', 'Georgia');
update tiny_houses_all set State = replace(State,'Rhode IsLouisianand', 'Rhode Island');
update tiny_houses_all set State = replace(State,'north Californiarolina', 'North Carolina');
update tiny_houses_all set State = replace(State,'Washingtonshington', 'Washington');
