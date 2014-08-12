require 'logger'
require 'yaml'


log = Logger.new('activity.log')
log.level = Logger::INFO
log.info('started logging')
sleep 2

#def getURL
config = YAML.load_file('config.yml')
baseURL = config['baseURL']
log.info(baseURL) 
#end

#getURL()
  

=begin
tracker1 = Thread.new do
  for a in 1..20
  a=1
  log.info ('Tracker 1 artifact created')
  a = a+1 
  end
end

tracker2 = Thread.new do 
  for i in 1..20
  i=1
  log.info ('Tracker 2 artifact created')
  i = i+1 
  end

end


tracker1.join
tracker2.join
=end 
