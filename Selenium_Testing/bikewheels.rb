## Navigate to and update options for a wheelset based on data in a .csv

require 'rubygems'
require 'selenium-webdriver'



options = Selenium::WebDriver::Chrome::Options.new ## one or all of these stop chrome from launching a view
caps = Selenium::WebDriver::Remote::Capabilities.chrome
caps.page_load_strategy='normal'

driver = Selenium::WebDriver.for(
  :chrome,
  :capabilities => [options, caps]
)

# set timeouts
driver.manage.timeouts.implicit_wait = 10
wait = Selenium::WebDriver::Wait.new(timeout: 20)


driver.navigate.to("https://bicyclewheelwarehouse.com/") ##https:// is required for navigate.to
e = driver.find_element(:text => "Road / Gravel Disc")
e.hover.find_element(:text, "GRAVEL/CX").click()

## trying to navigate to the gravel/cx wheels then find the one I want and update specs
