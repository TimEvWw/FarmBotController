
# read the test file and convert it into one command

require './FarmBotCommand'

class FarmBotTestFileHandler
	
	def self.readCommandFile
		cmd = FarmBotControlCommand.new
		cmd.lines = Array.new
		if File.file?('testcommands.csv')
			f = File.open('testcommands.csv','r')
			f.each_line do |line|
				if line.length > 5
					cmd_line = FarmBotControlCommandLine.new
					cmd_line.parseText( line )
					cmd.lines << cmd_line
				end
			end
		end
		cmd
	end
end
