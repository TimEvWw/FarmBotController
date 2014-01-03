# FarmBot Controller

#require "Rubygems"
#require "FarmBotControlInterfaceFirmataRamps14"
#require "FarmBotDbAccess"

# This module ties the different components for the FarmBot together
# It reads the next action from the database, executes it and reports back
# and it will initiate the synchronization with the web systems

class FarmBotControl

	def initialize	
		@inactiveCounter = 0
#		botHardware = BotControlInterface.new
#		botDb		= BotDbAccess.new
	end
	
	def runCycle

		# Retrieve next scheduled event from database
		
		nextEvent = nil
		#nextEvent = botDb.nextEvent
		if @nextEvent != nil # and nextEvent.isTimeToExecute
			
			# Execute event
		
			@inactiveCounter = 0
		
			#if nextEvent.Action == "MOV" botHardware.moveTo(nextEvent.X, nextEvent.Y, nextEvent.Z)
			#if nextEvent.Action == "SPD" botHardware.setSpeed(nextEvent.Speed)
			#if nextEvent.Action == "SHD" $shutdown = 1
		else			
			sleep 1
			
			if @inactiveCounter > 10
				@inactiveCounter = 0
				#botDb.synchronizeCloud
				puts 'Synchronize'
			else
				@inactiveCounter += 1
			end

		end
		
	end
end

$shutdown = 0

# Main loop for the bot. Keep cycling until quiting time
botThread = Thread.new { 

	bot = FarmBotControl.new
	while $shutdown == 0
		bot.runCycle
	end

}

# just a little menu for testing

while $shutdown == 0 do

	system('cls')
	system('clear')
	
	puts '[FarmBot Controller Menu]'
	puts ''
	puts 'q - quit'
	puts 's - status'
	input = gets
	puts ''
	
	case input.upcase[0]
		when "Q"
			$shutdown = 1
			puts 'Shutting down...'
		when "S"
			puts 'Not implemented yet. Press \'Enter\' key to continue.'
			gets
		end
	
end