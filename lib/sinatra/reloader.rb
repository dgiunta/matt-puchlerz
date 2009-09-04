# http://groups.google.com/group/sinatrarb/browse_thread/thread/a5cfc2b77a013a86

module Sinatra

  class Reloader < Rack::Reloader 
    
    def safe_load(file, mtime, stderr = $stderr) 
      if file == File.expand_path(Sinatra::Application.app_file)
        ::Sinatra::Application.reset! 
        stderr.puts "#{self.class}: reseting routes" 
      end 
      super 
    end 
    
  end

end