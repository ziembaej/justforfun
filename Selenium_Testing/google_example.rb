## google example
require 'rubygems'
require 'selenium-webdriver'
require 'jest'

driver = Selenium::WebDriver.for :chrome
driver.get "http://google.com"

element = driver.find_element :name => "q"
element.send_keys "Cheese!"
element.submit

puts "Page title is #{driver.title}"

wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.title.downcase.start_with? "cheese!" }

puts "Page title is #{driver.title}"
driver.quit

it('renders correctly', async () => {
    const page = await browser.newPage();
    await page.goto('https://www.google.com');
    const image = await page.screenshot();
  
    expect(image).toMatchImageSnapshot();
  });