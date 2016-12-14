Dir[File.dirname(__FILE__) + '/bin/helpers/*.rb'].each {|f| require f }
Dir[File.dirname(__FILE__) + '/bin/*.rb'].each {|f| require f }
Dir[File.dirname(__FILE__) + '/bin/processors/*.rb'].each {|f| require f }


entry_data = InputHandler.new ARGV
puts entry_data.username