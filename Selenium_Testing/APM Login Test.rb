
# These are notes
# pressing enter makes more notes
# if you want to start writing code
# hit backspace first to exit the note
# Need to make sure browser drivers are up to date.
#
# Download correct driver here: https://chromedriver.chromium.org/downloads
# unzip
# run
# sudo mv -f chromedriver /usr/local/share/chromedriver
# sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
# sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver
#

require 'rubygems'
require 'selenium-webdriver'


EZ = 'EZ'
nonsense = File.read('/Users/eric.ziemba/Documents/Local Analyses/nonsense.txt')


options = Selenium::WebDriver::Chrome::Options.new ## one or all of these stop chrome from launching a view
#options.add_argument('--headless')
#options.add_argument('--disable-gpu')
#options.add_argument('--disable-dev-shm-usage')
#options.add_argument('--no-sandbox')
caps = Selenium::WebDriver::Remote::Capabilities.chrome
caps.page_load_strategy='normal'

driver = Selenium::WebDriver.for(
  :chrome,
  :capabilities => [options, caps]

)
# set timeouts
driver.manage.timeouts.implicit_wait = 5
wait = Selenium::WebDriver::Wait.new(timeout: 20)


driver.navigate.to("https://hobbitonqa.qa.appfolio.com/") ##https:// is required for navigate.to
e = driver.find_element(:id, 'user_email')
e.send_keys(EZ)
print('1. entered username ')
pw = driver.find_element(:id, 'user_password')
pw.send_keys(nonsense)
l = driver.find_element(:id, 'log_in_button')
l.click()
print('2. click the login button ')
#wait.until {driver.find_element(:text, 'Dashboard').displayed?}
wait.until { driver.title.downcase.start_with? "Dashboard - AppFolio Property Manager" }

print(driver.title)
driver.quit()



stop





stop

univ_search = driver.find_element(:id, 'global-search-input')
univ_search.send_keys('Bilbo Baggins')





wait.until { driver.find_element('Bilbo Baggins').displayed? }

print("locate desired result")
e.click
print("clicked")

conf_company = driver.find_element_by_class('datapair_value')

puts conf_company.text
