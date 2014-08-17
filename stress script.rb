require 'logger'
require 'yaml'
require 'watir-webdriver'
require 'rubygems'

@log = Logger.new('activity.log')
@log.level = Logger::INFO
@log.info('started logging')
@config = YAML.load_file('config.yml')


def getURL
@baseURL = @config['baseURL']
end

def startBrowser
@browser = Watir::Browser.new :firefox
@browser.goto (@config['baseURL'])
end  

def createNewUser
startBrowser
@browser.text_field(:id => 'username').when_present.set(@config['adminUsername'])
@browser.text_field(:id => 'pwd').when_present.set(@config['adminPassword'])
@browser.link(:href => "javascript:submitForm(document.getElementById('localLogin'), 'submit');").click
@browser.link(:href => '/sf/sfmain/do/listProjectsAdmin').when_present.click
end



createNewUser

=begin
getURL
startBrowser
doAdminLogin 

tracker1 = Thread.new do
  getURL
  startBrowser
  doAdminLogin 
  end


tracker2 = Thread.new do 
  getURL
  startBrowser
  doAdminLogin 
  end

tracker1.join
tracker2.join

=end 
