# command message class that is put into the queue to execute by the farmbot

class FarmBotControlCommand

	def initialize
		commandid = "NOP"
	end

	attr_accessor :lines, :commandid
end

class FarmBotControlCommandLine
	attr_accessor :action
	attr_accessor :xCoord, :xHome
	attr_accessor :yCoord, :yHome
	attr_accessor :zCoord, :zHome
	attr_accessor :quantity, :speed	
end
