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
@users = ['user1','user2','user3','user4','user5']

def doLogin(usr,pwd)
profile = Selenium::WebDriver::Firefox::Profile.new
profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
profile['browser.privatebrowsing.autostart'] = true
@browser = Watir::Browser.new :firefox, :profile => profile
@browser.goto (@config['baseURL'])
@browser.text_field(:id =>'username').when_present.set(usr)
@browser.text_field(:id => 'pwd').when_present.set(pwd)
@browser.link(:href => "javascript:submitForm(document.getElementById('localLogin'), 'submit');").click
end

def reachToProject
@browser.link(:href => '/sf/sfmain/do/myProjects').when_present.click
@browser.link(:href => '/sf/projects/test_project').when_present.click #to_do: Create method for auto_project and pass project name as this method parameter.
end

def createNewUser
@browser.link(:href => '/sf/sfmain/do/listProjectsAdmin').when_present.click  
@browser.goto 'http://localhost:8080/sf/sfmain/do/listUsersAdmin'
for i in 1..50
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

end

def submitArtifact
@browser.link(:href => '/sf/tracker/do/listTrackers/projects.test_project/tracker').when_present.click
@browser.link(:href => '/sf/tracker/do/listArtifacts/projects.test_project/tracker.test_tracker').when_present.click 
@browser.link(:href => '/sf/tracker/do/createArtifact/projects.test_project/tracker.test_tracker').when_present.click
@browser.text_field(:id => 'title').when_present.set(Faker::Lorem::sentence)
@browser.text_field(:id => 'description').when_present.set(Faker::Lorem::paragraph)
@browser.link(:text => 'Save').when_present.click
@log.info('Artifact created')
end

def touchDiscussion
@browser.link(:href => '/sf/discussion/do/listForums/projects.test_project/discussion').when_present.click
@browser.link(:href => '/sf/discussion/do/listTopics/projects.test_project/discussion.test_forum').when_present.click
@browser.link(:text => 'Create').when_present.click
@browser.text_field(:id => 'title').when_present.set(Faker::Lorem::sentence)
@browser.text_field(:id => 'content').when_present.set(Faker::Lorem::paragraph)
@browser.link(:text => 'Save').when_present.click 
@log.info('Discussion topic Updated')

end

def touchWiki
@browser.link(:href => '/sf/wiki/do/viewPage/projects.test_project/wiki/HomePage').when_present.click
@browser.link(:text => 'Edit').when_present.click 
@browser.text_field(:id => 'editorarea').set(Faker::Lorem::paragraph)
@browser.link(:text => 'Update').when_present.click
end
 

 tracker1 = Thread.new do 
    doLogin('user1',@config['allUserPassword'])
    reachToProject 
    loop do
    availableActions = [touchWiki,touchDiscussion,submitArtifact]
    availableActions.sample
    end
  end
  
 tracker2 = Thread.new do 
    doLogin('user2',@config['allUserPassword'])
    reachToProject
    loop do
    availableActions = [touchWiki,touchDiscussion,submitArtifact]
    availableActions.sample
    end
  end
  
=begin
  tracker3 = Thread.new do 
    doLogin('user3',@config['allUserPassword'])
    reachToProject
    loop do 
    availableActions = [touchWiki,touchDiscussion,submitArtifact]
    availableActions.sample
    end
  end
  
  tracker4 = Thread.new do 
    doLogin(@users.sample,@config['allUserPassword'])
    reachToProject
    loop do 
    availableActions = [touchWiki,touchDiscussion,submitArtifact]
    availableActions.sample
  end 
  
  tracker5 = Thread.new do 
    doLogin(@users.sample,@config['allUserPassword'])
    reachToProject
    loop do 
    availableActions = [touchWiki,touchDiscussion,submitArtifact]
    availableActions.sample
  end 
  
  end
  
  admin1 = Thread.new do
    doLogin(@config['adminUsername'],@config['adminPassword'])
    reachToProject
    loop do
      createNewUser
    end
  end
=end

    
  
    
tracker1.join
tracker2.join
#admin1.join

 

