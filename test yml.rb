require 'yaml'

url =YAML.load_file('config.yml')
puts url['baseURL']


