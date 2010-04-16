#\ -E none -p 9292

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new 'log/sinatra.log', 'a'
STDOUT.reopen log
STDERR.reopen log

require 'app'
run Sinatra::Application