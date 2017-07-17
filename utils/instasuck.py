#!/usr/bin/python

import urllib
import os
import time
import json

from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

prev_url = ""
with open('instasuck_prev_url.txt', 'r') as f:
    prev_url = f.read()

if True:
    browser = webdriver.Chrome()

    # search by hashtag
    browser.get('https://www.instagram.com/explore/tags/bowanddrape/')
    # hide trending?
    #browser.execute_script('document.querySelector(\'article div:first-of-type\').style.display = \'none\';')

    timeout = 1
    try:
        element_present = EC.presence_of_element_located((By.ID, '#pImage_9'))
        WebDriverWait(browser, timeout).until(element_present)
    except TimeoutException:
        pass

    image = browser.find_element(By.ID, 'pImage_9')
    description = image.get_attribute('alt').encode('utf-8')
    #print image.get_attribute('src')
    # download the image?
    #urllib.urlretrieve(image.get_attribute('src'), 'downloaded.jpg')
    link = image.find_element_by_xpath('../../..')
    url = link.get_attribute('href')

    browser.quit()

    if not prev_url:
        prev_url = url
        with open('instasuck_prev_url.txt', 'w') as f:
            f.write(prev_url)
    elif url != prev_url:
        prev_url = url
        with open('instasuck_prev_url.txt', 'w') as f:
            f.write(prev_url)
        urllib.urlopen('https://hooks.slack.com/services/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', json.dumps({'as_user':False,'username':'social','icon_emoji':':camera:','text':'<{}|instagram> {}'.format(url, description)}))

    #time.sleep(30)


