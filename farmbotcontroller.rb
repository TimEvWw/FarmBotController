# FarmBot schedule 

# This module reads the schedule from the mongodb. If a scheduled event is found, send the actions to the bot.

require "Rubygems"
require "firmata"

$shutdown = 0

# a few database classes

class BotSchedule
	include MongoMapper::Document

	many	:BotScheduleActions

	# BotScheduleId		: unique id used to synchronize with cloud
	# CropId			: unique id used to synchronize with cloud
	# TimeScheduled		: time to start executing the actions
	# TimeExecuted		: time when actions are executed
	# Status			: a three letter status
	#						SYN	: synchronizing
	#						RTS	: ready to start
	#						STA	: started
	#						ERR	: error
	#						DNE	: done
	#						RPT : reported back to the cloud
end


class BotScheduleAction

	include MongoMapper::EmbeddedDocument
	
	belongs_to	:botschedule
	
	# Action		: representation of the action to do
	#					MOV	: move to x, y, z
	#					SPD	: set speed
	#					SHD	: shutdown bot
	#					SSD	: set synchronization speed with cloud
	#					also needed later on: inject seed, pickup seed, water, ...
	# X				: X coordinate
	# Y				: Y coordinate
	# Z				: Z coordinate
	# Speed			: Speed setting
	#					FST		: fast movement for moving across a field
	#					WRK		: work speed, used for slow movement like digging, weeding, ...
	# Quantity		: Quantity of water or fertilizer to dose
		
end


# classes to control the hardware

class BotControlInterfae
	
	def moveTo( X, Y, Z )
	end
	
	def moveHome
	end
	
	def setSpeed( speed )
	end
end

=begin

# specific implementation to control the bot using marlin software on arduino and G-Code

class BotControlMarlin
	
	def initialize
		serialPort = ...
	end
	
	def moveTo( X, Y, Z )
		serialPort.Send("G21 X#{X} Y#{Y} Z#{Z}")
	end
	
	def moveHome
		serialPort.Send("G20")
	end
	
	def setSpeed( speed )
	end
end
=end

# specific implementation to control the bot using the firmata protocol and the ramps board version 1.4

class BotControlFirmataRamps14 < BotControlInterfae

	pos_X = 0.0
	pos_Y = 0.0
	pos_Z = 0.0
	
	# should come from configuration:
	steps_per_unit_X = 100 # steps per milimeter for example
	steps_per_unit_Y = 100
	steps_per_unit_Z = 100
		
	board_device = "/dev/ttyACM0"

	pin_step_X = 54
	pin_dire_X = 55
	pin_enbl_X = 38
	
	def initialize
		board = Firmata::Board.new board_device
	end

	def moveTo( X, Y, Z )
		
			board.digital_write(pin_enbl_X, 0)
				
			if (X < pos_X)
				board.digital_write(pin_dire_X, 1)
			else
				board.digital_write(pin_dire_X, 0)

			while (X - pos_X).abs < 1/steps_per_unit_X
				board.digital_write(pin_step_X, 1)
				sleep 0.001
				board.digital_write(pin_step_X, 0)
				sleep 0.001
			end
			
			board.digital_write(pin_enbl_X, 1)
		end
	
	end
	
end

# bot control classes
# direct all access to database and hardware actions

class botControl

	inactiveCounter = 0

	def initialize
		botHardware = BotControlFirmataRamps14.new
		botDb = ...
	end

	def runCycle
	
		# retrieve next scheduled event from database
				
		nextEvent = botDb.nextEvent
		if !nextEvent == nil do
		
			inactiveCounter = 0
		
			if nextEvent.Action == "MOV" botHardware.moveTo(nextEvent.X, nextEvent.Y, nextEvent.Z)
			if nextEvent.Action == "SPD" botHardware.setSpeed(nextEvent.Speed)
			if nextEvent.Action == "SHD" $shutdown = 1
		else			
			sleep 1
			
			if inactiveCounter > 10 do
				inactiveCounter = 0
				botDb.synchronizeCloud
			else
				inactiveCounter += 1
			end
			
		end
		
	end
end

# Main loop for the bot. Here it loops until shut down

bot = botControl.new
while !$shutdown do
	bot.runCycle
end
