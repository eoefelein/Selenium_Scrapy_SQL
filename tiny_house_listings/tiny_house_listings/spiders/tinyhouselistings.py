# -*- coding: utf-8 -*-
import json
import time
import scrapy
from scrapy.http import Request
from scrapy.crawler import CrawlerProcess

class TinyhouselistingsSpider(scrapy.Spider):
    name = 'tinyhouselistings'
    listings_url = 'https://thl-prod.global.ssl.fastly.net/api/v1/listings/search?area_min=0&measurement_unit=feet&page={}'
    
    #sends the initial scrapy request to our URL and calls parse
    def start_requests(self):
        page = 1
        yield scrapy.Request(url=self.listings_url.format(page),
            meta={"page": page},
            callback=self.parse)

    def parse(self, response):
        listings = json.loads(response.body)
        for ad in listings['listings']:
            yield ad
        
        page = int(response.meta['page']) + 1
        if page < int(listings['meta']['pagination']['page_count']):
            yield scrapy.Request(url=self.listings_url.format(page),
                meta={"page": page},
                callback=self.parse)