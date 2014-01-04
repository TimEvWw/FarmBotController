# FarmBot Controller

#require "Rubygems"
#require "FarmBotDbAccess"

require "./FarmBotControlInterfaceFirmataRamps14.rb"
require './FarmBotCommand.rb'

# This module ties the different components for the FarmBot together
# It reads the next action from the database, executes it and reports back
# and it will initiate the synchronization with the web systems

class FarmBotControl

	def initialize	
		@inactiveCounter 	= 0
	end
	
	def runCycle

		if $commandQueue.empty? == false

			command = $commandQueue.pop
			command.lines.each do |commandLine|
				case commandLine.action.upcase
					when "MOVE ABSOLUTE"
						puts "move absolute"
					when "MOVE RELATIVE"
						$botHardware.moveRelative(commandLine.xCoord, commandLine.yCoord, commandLine.zCoord)
					when "MOVE HOME"
						puts "move home"
					when "SET SPEED"
						puts "set speed"
					when "SHUTDOWN"
						puts "shutdown"
						$shutdown = 1
				end

			end			
			#$commandFinished << command if command.commandid != nil and command.commandid > 0
		else
			sleep 0.1
		end
		
	end
end

$botHardware 		= FarmBotControlInterface.new
$shutdown			= 0
$commandQueue		= Queue.new
$commandFinished	= Queue.new
#botDb				= BotDbAccess.new


# Main loop for the bot. Keep cycling until quiting time
botThread = Thread.new { 

	bot = FarmBotControl.new
	while $shutdown == 0
		bot.runCycle
	end

}

# just a little menu for testing

$moveSize = 100

while $shutdown == 0 do

	#system('cls')
	#system('clear')
	
	puts '[FarmBot Controller Menu]'
	puts ''
	puts 'p - stop'
	puts 'o - status'
	puts 't - test'
	puts ''
	puts "move size = #{$moveSize}"
	puts ''
	puts 'w - up'
	puts 's - down'
	puts 'a - left'
	puts 'd - right'
	puts ''
	puts 'e - home'	
	puts 'q - step size'	
	puts ''
	print 'command > '
	input = gets
	puts ''
	
	case input.upcase[0]
		when "P" # Quit
			$shutdown = 1
			puts 'Shutting down...'
		when "O" # Get status
			puts 'Not implemented yet. Press \'Enter\' key to continue.'
			gets

		when "Q" # Set step size
			print 'Enter new step size > '
			moveSizeTemp = gets
			$moveSize = moveSizeTemp.to_i if moveSizeTemp.to_i > 0
		when "E" # Move to home
		
			# create the command
			newCommand = FarmBotControlCommand.new
			newCommand.commandid = 0
			
			# add lines with the right actions to the command
			newLine = FarmBotControlCommandLine.new
			newLine.action = "MOVE TO HOME"
			newCommand.lines = [newLine]
			
			# put the command into the queue for execution
			$commandQueue << newCommand
		when "W" # Move up
		
			# create the command
			newCommand = FarmBotControlCommand.new
			newCommand.commandid = 0
			
			# add lines with the right actions to the command
			newLine = FarmBotControlCommandLine.new
			newLine.action = "MOVE RELATIVE"
			newLine.xCoord = 0
			newLine.yCoord = $moveSize
			newLine.zCoord = 0
			newCommand.lines = [newLine]
			
			# put the command into the queue for execution
			$commandQueue << newCommand
		when "S" # Move down
		
			# create the command
			newCommand = FarmBotControlCommand.new
			newCommand.commandid = 0
			
			# add lines with the right actions to the command
			newLine = FarmBotControlCommandLine.new
			newLine.action = "MOVE RELATIVE"
			newLine.xCoord = 0
			newLine.yCoord = -$moveSize
			newLine.zCoord = 0
			newCommand.lines = [newLine]
			
			# put the command into the queue for execution
			$commandQueue << newCommand
		when "A" # Move left
		
			# create the command
			newCommand = FarmBotControlCommand.new
			newCommand.commandid = 0
			
			# add lines with the right actions to the command
			newLine = FarmBotControlCommandLine.new
			newLine.action = "MOVE RELATIVE"
			newLine.xCoord = -$moveSize
			newLine.yCoord = 0
			newLine.zCoord = 0
			newCommand.lines = [newLine]
			
			# put the command into the queue for execution
			$commandQueue << newCommand
		when "D" # Move right
		
			# create the command
			newCommand = FarmBotControlCommand.new
			newCommand.commandid = 0
			
			# add lines with the right actions to the command
			newLine = FarmBotControlCommandLine.new
			newLine.action = "MOVE RELATIVE"
			newLine.xCoord = $moveSize
			newLine.yCoord = 0
			newLine.zCoord = 0
			newCommand.lines = [newLine]
			
			# put the command into the queue for execution
			$commandQueue << newCommand
		end
	
end