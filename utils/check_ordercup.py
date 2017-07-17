#!/usr/bin/python

import urllib
import os
import re
import time
import json

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By


if True:
    browser = webdriver.Chrome()

    # empty download directory
    for filename in os.listdir('/home/ubuntu/Downloads/'):
        if re.search('\.xml$', filename):
            os.unlink('/home/ubuntu/Downloads/{}'.format(filename));

    # login
    browser.get('https://ship.ordercup.com/session/new')

    timeout = 3
    try:
        element_present = EC.presence_of_element_located((By.ID, '#session_login'))
        WebDriverWait(browser, timeout).until(element_present)
    except TimeoutException:
        pass

    browser.find_element(By.ID, 'session_login').send_keys('bowanddrape')
    browser.find_element(By.ID, 'session_password').send_keys('precision')
    browser.find_element(By.ID, 'session_password').send_keys(Keys.ENTER)
    browser.get('https://ship.ordercup.com/stores/bowdrapes_6/packages')

    try:
        element_present = EC.presence_of_element_located((By.ID, 'packageExportSubmitButton'))
        WebDriverWait(browser, timeout).until(element_present)
    except TimeoutException:
        pass

    browser.find_element_by_xpath('//*[contains(text(), "Yesterday")]').click()
    browser.execute_script('showPackageExportDialog("xml");')
    browser.execute_script('$("#packageExportSubmitButton").click()')

    browser.get('https://aws.bowanddrape.com')
    browser.find_element(By.NAME, 'email').send_keys('graphicsforge@gmail.com')
    browser.find_element(By.NAME, 'password').send_keys('gemini')
    browser.find_element(By.NAME, 'password').send_keys(Keys.ENTER)

    browser.get('https://aws.bowanddrape.com/index.php/orders/ordersXMLImport');

    # upload xmls
    for filename in os.listdir('/home/ubuntu/Downloads/'):
        if re.search('\.xml$', filename):
            browser.find_element(By.NAME, 'file').send_keys('/home/ubuntu/Downloads/{}'.format(filename))

    browser.quit()

    #time.sleep(7200)


