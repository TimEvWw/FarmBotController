# FarmBot Controller

#require "Rubygems"
#require "FarmBotDbAccess"

require "./FarmBotControlInterfaceFirmataRamps14.rb"
require './FarmBotCommand.rb'
require './filehandler.rb'

# This module ties the different components for the FarmBot together
# It reads the next action from the database, executes it and reports back
# and it will initiate the synchronization with the web systems

class FarmBotControl

	def initialize	
		@inactiveCounter 	= 0
	end
	
	def runCycle

		if $command_queue.empty? == false

			command = $command_queue.pop
			command.lines.each do |command_line|
				case command_line.action.upcase
					when "MOVE ABSOLUTE"
						$bot_hardware.moveAbsolute(command_line.xCoord, command_line.yCoord, command_line.zCoord)
					when "MOVE RELATIVE"
						$bot_hardware.moveRelative(command_line.xCoord, command_line.yCoord, command_line.zCoord)
					when "HOME X"
						$bot_hardware.moveHomeX
					when "HOME Y"
						$bot_hardware.moveHomeY
					when "HOME Z"
						$bot_hardware.moveHomeZ
					when "SET SPEED"
						$bot_hardware.setSpeed(command_line.speed)
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

$bot_hardware 		= FarmBotControlInterface.new
$bot_control		= FarmBotControl.new

$shutdown		= 0
$command_queue		= Queue.new
$command_finished	= Queue.new

#botDb				= BotDbAccess.new

# *thread disabled for now*
# Main loop for the bot. Keep cycling until quiting time
#bot_thread = Thread.new { 
#
#	bot = FarmBotControl.new
#	while $shutdown == 0
#		bot.runCycle
#	end
#
#}

# just a little menu for testing

$move_size = 100

while $shutdown == 0 do

	#system('cls')
	#system('clear')
	
	puts '[FarmBot Controller Menu]'
	puts ''
	puts 'p - stop'
#	puts 'o - status'
	puts 't - execute test file'
	puts ''
	puts "move size = #{$move_size}"
	puts ''
	puts 'w - forward'
	puts 's - back'
	puts 'a - left'
	puts 'd - right'
	puts 'r - up'
	puts 'f - down'
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
			move_size_temp = gets
			$move_size = move_size_temp.to_i if move_size_temp.to_i > 0
		when "T" # Execute test file
		
			# read the file
			new_command = FarmBotTestFileHandler.readCommandFile
			new_command.commandid = 0
			
			# put the command into the queue for execution
			$command_queue << new_command
		when "E" # Move to home
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE TO HOME"
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command
		when "W" # Move forward
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE RELATIVE"
			new_line.xCoord = 0
			new_line.yCoord = $move_size
			new_line.zCoord = 0
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command
		when "S" # Move back
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE RELATIVE"
			new_line.xCoord = 0
			new_line.yCoord = -$move_size
			new_line.zCoord = 0
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command
		when "A" # Move left
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE RELATIVE"
			new_line.xCoord = -$move_size
			new_line.yCoord = 0
			new_line.zCoord = 0
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command
		when "D" # Move right
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE RELATIVE"
			new_line.xCoord = $move_size
			new_line.yCoord = 0
			new_line.zCoord = 0
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command

		when "R" # Move up
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE RELATIVE"
			new_line.xCoord = 0
			new_line.yCoord = 0
			new_line.zCoord = $move_size
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command
		when "F" # Move down
		
			# create the command
			new_command = FarmBotControlCommand.new
			new_command.commandid = 0
			
			# add lines with the right actions to the command
			new_line = FarmBotControlCommandLine.new
			new_line.action = "MOVE RELATIVE"
			new_line.xCoord = 0
			new_line.yCoord = 0
			new_line.zCoord = -$move_size
			new_command.lines = [new_line]
			
			# put the command into the queue for execution
			$command_queue << new_command

		end

	$bot_control.runCycle
	
end
