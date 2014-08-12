require 'yaml'

url =YAML.load_file('connection.yml')
puts url['baseURL']

