require 'firmata'
require './FarmBotControlInterface.rb'

class FarmBotControlInterface # < FarmBotControlInterfaceAbstract

	def initialize
		@posX = 0.0
		@posY = 0.0
		@posZ = 0.0
		
		# should come from configuration:
		@stepsPerUnit_X = 10 # steps per milimeter for example
		@stepsPerUnit_Y = 10
		@stepsPerUnit_Z = 10
			
		@boardDevice = "/dev/ttyACM0"

		@pinStepX = 54
		@pinDireX = 55
		@pinEnblX = 38
		
		@board = Firmata::Board.new @boardDevice
		@board.connect
		@board.set_pin_mode(pinEnblX, Firmata::Board::OUTPUT)
		@board.set_pin_mode(pinDireX, Firmata::Board::OUTPUT)
		@board.set_pin_mode(pinStepX, Firmata::Board::OUTPUT)
	end

	def moveRelative( xAmount, yAmount, zAmount)
		
		puts '**moveRelative**'
		puts "xAmount #{xAmount}"
	
		@board.digital_write(pinEnblX, Firmata::Board::HIGH)
	
		if xAmount < 0
			@board.digital_write(pinDireX, Firmata::Board::HIGH)
		end
	
		if xAmount > 0
			@board.digital_write(pinDireX, Firmata::Board::LOW)
		end

		for i in 1..xAmount * stepsPerUnit
			@board.digital_write(pinStepX, Firmata::Board::HIGH)
			sleep 0.001
			@board.digital_write(pinStepX, Firmata::Board::LOW)
			sleep 0.001
			posX += 1/stepsPerUnit
		end
		
		@board.digital_write(pinEnblX, Firmata::Board::LOW)
			
		#while (X - pos_X).abs < 1/steps_per_unit_X
					
	end	
end