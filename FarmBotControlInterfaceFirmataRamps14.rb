require 'FarmBotControlInterface'

class FarmBotControlInterface < FarmBotControlInterfaceAbstract

	@pos_X = 0.0
	@pos_Y = 0.0
	@pos_Z = 0.0
	
	# should come from configuration:
	@steps_per_unit_X = 100 # steps per milimeter for example
	@steps_per_unit_Y = 100
	@steps_per_unit_Z = 100
		
	@board_device = "/dev/ttyACM0"

	@pin_step_X = 54
	@pin_dire_X = 55
	@pin_enbl_X = 38
	
	def initialize
		@board = Firmata::Board.new board_device
	end

	def moveTo( X, Y, Z )
		
			@board.digital_write(pin_enbl_X, 0)
				
			if (X < pos_X)
				@board.digital_write(pin_dire_X, 1)
			else
				@board.digital_write(pin_dire_X, 0)

			while (X - pos_X).abs < 1/steps_per_unit_X
				@board.digital_write(pin_step_X, 1)
				sleep 0.001
				@board.digital_write(pin_step_X, 0)
				sleep 0.001
			end
			
			@board.digital_write(pin_enbl_X, 1)
		end
	
	end
	
end