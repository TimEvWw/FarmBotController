require 'firmata'
require './FarmBotControlInterface.rb'

class FarmBotControlInterface # < FarmBotControlInterfaceAbstract

	def initialize
		@pos_x = 0.0
		@pos_y = 0.0
		@pos_z = 0.0
		
		# should come from configuration:
		@steps_per_unit_x = 10 # steps per milimeter for example
		@steps_per_unit_y = 10
		@steps_per_unit_z = 10
			
		@boardDevice = "/dev/ttyACM0"

		@pin_led = 13

		@pin_step_x = 54
		@pin_dire_x = 55
		@pin_enbl_x = 38

		@pin_step_y = 60
		@pin_dire_y = 61
		@pin_enbl_y = 56

		@pin_step_z = 46
		@pin_dire_z = 48
		@pin_enbl_z = 62
		
		@board = Firmata::Board.new @boardDevice
		@board.connect

		@board.set_pin_mode(@pin_enbl_x, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_dire_x, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_step_x, Firmata::Board::OUTPUT)

		@board.set_pin_mode(@pin_enbl_y, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_dire_y, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_step_y, Firmata::Board::OUTPUT)

		@board.set_pin_mode(@pin_enbl_z, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_dire_z, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_step_z, Firmata::Board::OUTPUT)

		@board.digital_write(@pin_enbl_x, Firmata::Board::HIGH)
		@board.digital_write(@pin_enbl_y, Firmata::Board::HIGH)
		@board.digital_write(@pin_enbl_z, Firmata::Board::HIGH)
	end

	def moveRelative( amount_x, amount_y, amount_z)
		
		puts '**moveRelative**'
		puts "x #{amount_x}"
		puts "y #{amount_y}"
		puts "z #{amount_z}"
		
		if amount_x < 0
			@board.digital_write(@pin_enbl_x, Firmata::Board::LOW)
			@board.digital_write(@pin_dire_x, Firmata::Board::LOW)
		end
	
		if amount_x > 0
			@board.digital_write(@pin_enbl_x, Firmata::Board::LOW)
			@board.digital_write(@pin_dire_x, Firmata::Board::HIGH)
		end

		if amount_y < 0
			@board.digital_write(@pin_enbl_y, Firmata::Board::LOW)
			@board.digital_write(@pin_dire_y, Firmata::Board::LOW)
		end
	
		if amount_y > 0
			@board.digital_write(@pin_enbl_y, Firmata::Board::LOW)
			@board.digital_write(@pin_dire_y, Firmata::Board::HIGH)
		end

		if amount_z < 0
			@board.digital_write(@pin_enbl_z, Firmata::Board::LOW)
			@board.digital_write(@pin_dire_z, Firmata::Board::LOW)
		end
	
		if amount_z > 0
			@board.digital_write(@pin_enbl_z, Firmata::Board::LOW)
			@board.digital_write(@pin_dire_z, Firmata::Board::HIGH)
		end

		for i in 1..amount_x.abs * @steps_per_unit_x
			@board.digital_write(@pin_step_x, Firmata::Board::HIGH)
			sleep 0.001
			@board.digital_write(@pin_step_x, Firmata::Board::LOW)
			sleep 0.001
			@pos_x += 1 / @steps_per_unit_x
		end

		for i in 1..amount_y.abs * @steps_per_unit_y
			@board.digital_write(@pin_step_y, Firmata::Board::HIGH)
			sleep 0.001
			@board.digital_write(@pin_step_y, Firmata::Board::LOW)
			sleep 0.001
			@pos_y += 1 / @steps_per_unit_y
		end
		
		for i in 1..amount_z.abs * @steps_per_unit_z
			@board.digital_write(@pin_step_z, Firmata::Board::HIGH)
			sleep 0.001
			@board.digital_write(@pin_step_z, Firmata::Board::LOW)
			sleep 0.001
			@pos_z += 1 / @steps_per_unit_z
		end

		@board.digital_write(@pin_enbl_x, Firmata::Board::HIGH)
		@board.digital_write(@pin_enbl_y, Firmata::Board::HIGH)
		@board.digital_write(@pin_enbl_z, Firmata::Board::HIGH)
			
		#while (X - pos_X).abs < 1/steps_per_unit_X

		puts '*move done*'
					
	end	
end
