require 'octokit'
require 'date'
require 'json'

Dir[File.dirname(__FILE__) + '/bin/helpers/*.rb'].each {|f| require f }
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|f| require f }
Dir[File.dirname(__FILE__) + '/bin/processors/*.rb'].each {|f| require f }


entry_data = InputHandler.new ARGV
worker_class = Object.const_get(entry_data.entity.capitalize)

worker = worker_class.new entry_data
worker.send(entry_data.type)
