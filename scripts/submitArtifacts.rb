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
@browser.text_field(:id =>'username').when_present.set('user1')
@browser.text_field(:id => 'pwd').when_present.set(@config['allUserPassword'])
@browser.link(:href => "javascript:submitForm(document.getElementById('localLogin'), 'submit');").click
@browser.link(:href => '/sf/sfmain/do/myProjects').when_present.click
@browser.link(:href => '/sf/projects/test_project').when_present.click 
@browser.link(:href => '/sf/tracker/do/listTrackers/projects.test_project/tracker').when_present.click
@browser.link(:href => '/sf/tracker/do/listArtifacts/projects.test_project/tracker.test_tracker').when_present.click 
loop do
@browser.link(:href => '/sf/tracker/do/createArtifact/projects.test_project/tracker.test_tracker').when_present.click
@browser.text_field(:id => 'title').when_present.set(Faker::Lorem::sentence)
@browser.text_field(:id => 'description').when_present.set(Faker::Lorem::paragraph)
@browser.link(:text => 'Save').when_present.click
@log.info('Artifact created')
end