require 'logger'
require 'yaml'
require 'watir-webdriver'
require 'rubygems'
require 'faker'

@log = Logger.new('activity.log')
@log.level = Logger::INFO
@log.info('started logging')
@config = YAML.load_file('config.yml')
@users = ['user1','user2','user3','user4','user5']


def doLogin(usr,pwd)
@browser = Watir::Browser.new :firefox
@browser.goto (@config['baseURL'])
@browser.text_field(:id =>'username').when_present.set(usr)
@browser.text_field(:id => 'pwd').when_present.set(pwd)
@browser.link(:href => "javascript:submitForm(document.getElementById('localLogin'), 'submit');").click
end

def createNewUser
doLogin(@config['adminUsername'],@config['adminPassword'])
@browser.link(:href => "javascript:submitForm(document.getElementById('localLogin'), 'submit');").click
@browser.link(:href => '/sf/sfmain/do/listProjectsAdmin').when_present.click  
@browser.goto 'http://localhost:8080/sf/sfmain/do/listUsersAdmin'
for i in 1..50
usr = (Faker::Lorem::word)
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

end

def submitArtifact
doLogin(@users.sample,@config['allUserPassword'])
@browser.link(:href => 'href="/sf/sfmain/do/myPage').when_present.click
@browser.link(:href => 'href="/sf/sfmain/do/myProjects').when_present.click
end


submitArtifact 

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
