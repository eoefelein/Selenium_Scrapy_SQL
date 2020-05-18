from selenium import webdriver
from selenium.webdriver import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
import pandas as pd
from bs4 import BeautifulSoup
import lxml
import os

driver_location = 'C:/Users/oefel/Downloads/geckodriver-v0.26.0-win64'
os.environ['webdriver.firefox.driver'] = driver_location 
driver = webdriver.Firefox(driver_location)
driver.get("https://www.tinyhomebuilders.com/tiny-house-marketplace/search")
driver.implicitly_wait(50)
driver.maximize_window()

tiny_house_titles = []
tiny_bed_bath_area = []
tiny_property_type = []
tiny_house_price = []

page_count = 1
max_page_count = 76

while page_count < max_page_count:
    driver.get(
        "https://www.tinyhomebuilders.com/tiny-house-marketplace/search?page={}".format(
            page_count
        )
    )

    scraped_titles = driver.find_elements_by_css_selector(
        "div.card-body > h3.card-title"
    )
    for title in scraped_titles:
        tiny_house_titles.append(title.text.strip())

    scraped_price = driver.find_elements_by_css_selector("div.card-body > div.price")
    for price in scraped_price:
        tiny_house_price.append(price.text.strip())

    scraped_bed_bath_size = driver.find_elements_by_css_selector(
        "div.card-body > div.beds_baths_sqft > span"
    )
    for size in scraped_bed_bath_size:
        tiny_bed_bath_area.append(size.text.strip())

    scraped_property_type = driver.find_elements_by_css_selector(
        "div.card-body > div.propertyType"
    )
    for property_type in scraped_property_type:
        tiny_property_type.append(property_type.text.strip())

    driver.find_element_by_link_text(str(page_count)).click()
    page_count += 1
tiny_bed_bath = tiny_bed_bath_area[::2]
tiny_area = tiny_bed_bath_area[1::2]

tiny_house_marketplace = pd.DataFrame(list(zip(tiny_house_titles, tiny_bed_bath, tiny_area, tiny_property_type, tiny_house_price)), columns = ['title', 'bed & bath', 'area', 'property_type, city & state', 'price'])
tiny_house_marketplace.to_csv('tiny_house_marketplace.csv', sep ='|')

driver.close()