
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

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--no-sandbox')

driver = Selenium::WebDriver.for(
  :chrome,
  options: options
)

begin
  driver.navigate.to("https://www.ebay.com")

end




puts driver.title

driver.quit
