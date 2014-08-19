require 'logger'
require 'yaml'
require 'watir-webdriver'
require 'rubygems'
require 'faker'
require 'securerandom'

@log = Logger.new('activity.log')
@log.level = Logger::INFO
@log.info('started logging')
@config = YAML.load_file('config.yml')

profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
profile['browser.privatebrowsing.autostart'] = true
@browser = Watir::Browser.new :firefox, :profile => profile
@browser.goto (@config['baseURL'])
@browser.text_field(:id =>'username').when_present.set(@config['adminUsername'])
@browser.text_field(:id => 'pwd').when_present.set(@config['adminPassword'])
@browser.link(:href => "javascript:submitForm(document.getElementById('localLogin'), 'submit');").click
@browser.link(:href => '/sf/sfmain/do/myProjects').when_present.click
@browser.link(:href => '/sf/projects/test_project').when_present.click
@browser.link(:href => '/sf/sfmain/do/listProjectsAdmin').when_present.click
@browser.goto 'http://localhost:8080/sf/sfmain/do/listUsersAdmin'
loop do
usr = (Faker::Lorem::word) + SecureRandom::random_number(4).to_s 
pwd = (Faker::Internet::password)  
@browser.link(:id => 'allUsers_create').when_present.click
@browser.text_field(:id => 'UsernameField').when_present.set(usr) 
@browser.text_field(:id => 'pwd').when_present.set(pwd)
@browser.text_field(:id => 'confirmpwd').when_present.set(pwd)
@browser.text_field(:id => 'fullName').when_present.set(Faker::Name::name)
@browser.text_field(:id => 'email').when_present.set(Faker::Internet::email)
@browser.text_field(:id => 'companyName').when_present.set('BVision')
@browser.link(:text => 'Create').click 
@log.info('user created')
sleep (@config['newUserInterval'])
end
  






