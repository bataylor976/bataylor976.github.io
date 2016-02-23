#!/usr/bin/env python3
# Sign in script for LastPass, Outlook ORNL, and Slack.

# Selenium webdriver: python module for browser automation and testing.
from selenium import webdriver

# FirefoxProfile: a module within selenium allowing you to opt for a specific 
# user's firefox profile, rather than the default browser used for web testing.
from selenium.webdriver.firefox.webdriver import FirefoxProfile

# Use selenium webdriver to send keystrokes to browser.
from selenium.webdriver.common.keys import Keys

# More secure than leaving the password as plaintext in the script.
import getpass
pswd = getpass.getpass('Password:')

# Select my firefox profile and pass it to variable 'profile'.
# Note: "qdjktc0p.default" will be different for each user.
profile = FirefoxProfile('/home/pupi/.mozilla/firefox/qdjktc0p.default/')
browser = webdriver.Firefox(profile)
browser.maximize_window()

# wait up to 30 seconds for page elements to load before returning error. 
browser.implicitly_wait(30)

# HTTP GET request.
browser.get('https://lastpass.com/?ac=1&lpnorefresh=1')

# Find location of 'email' textbox and pass it to variable.
emailElem = browser.find_element_by_id('email')

# Send email address as keystokes.
emailElem.send_keys('bataylor976@gmail.com')

# Find location of password textbox and pass to variable.
emailElem = browser.find_element_by_id('password')

# Send value entered in pswd variable (see above) as keystrokes.
emailElem.send_keys(pswd)

# Submit pswd to website.
emailElem.submit()
# Find the "Sign In" button on the page.
loginElem = browser.find_element_by_id('buttonsigningo')

# Send the equivalent of a mouseclick.
loginElem.click()

# Open a new tab in a browser.
body = browser.find_element_by_tag_name("body")
body.send_keys(Keys.CONTROL + 't')

# Get request for ORNL Outlook.
browser.get('https://mail.ornl.gov')

# Find location of Sigin In, but this time by its CSS selector value.
linkElem = browser.find_element_by_css_selector('.signinbutton > img:nth-child(1)')
linkElem.click()

# Open another tab to sign in to Slack.
body = browser.find_element_by_tag_name("body")
body.send_keys(Keys.CONTROL + 't')

# Get request for CWR's Slack page.
browser.get('https://cwr.slack.com')

# Couldn't figure why Selenium wouldn't locate the 'button'. Perhaps it does better with html than jquery? Opted instead for pyautogui, a module that primarily automates keyboard and mouse I/O.
# Pyautogui requires screen coordinates for mouse positions. Had to use a little mouse positioning script I wrote to find them. Tedious.
# (x, y, seconds)
pyautogui.moveTo(829, 529, 1)
pyautogui.click()

# Arbitrary pause to allow loading of page elements and objects.
pyautogui.PAUSE = 3

pyautogui.moveTo(948, 120, 2)
pyautogui.PAUSE = 1
pyautogui.click()

#Changed because Firefox updated and slightly changed the window features (1-28-16).
#pyautogui.moveTo(454, 180, 1). More tedium. 
pyautogui.moveTo(447, 220, 1)
pyautogui.PAUSE = 1
pyautogui.click()
