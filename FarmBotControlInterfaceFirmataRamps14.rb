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

		@pin_stp_x = 54
		@pin_dir_x = 55
		@pin_enb_x = 38

		@pin_stp_y = 60
		@pin_dir_y = 61
		@pin_enb_y = 56

		@pin_stp_z = 46
		@pin_dir_z = 48
		@pin_enb_z = 62

		@pin_min_x = 3
		@pin_max_x = 2

		@pin_min_y = 14
		@pin_max_y = 15

		@pin_min_z = 18
		@pin_max_z = 19
		
		@board = Firmata::Board.new @boardDevice
		@board.connect

		# set motor driver pins to output and set enables for the drivers to off

		@board.set_pin_mode(@pin_enb_x, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_dir_x, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_stp_x, Firmata::Board::OUTPUT)

		@board.set_pin_mode(@pin_enb_y, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_dir_y, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_stp_y, Firmata::Board::OUTPUT)

		@board.set_pin_mode(@pin_enb_z, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_dir_z, Firmata::Board::OUTPUT)
		@board.set_pin_mode(@pin_stp_z, Firmata::Board::OUTPUT)

		@board.digital_write(@pin_enb_x, Firmata::Board::HIGH)
		@board.digital_write(@pin_enb_y, Firmata::Board::HIGH)
		@board.digital_write(@pin_enb_z, Firmata::Board::HIGH)

		# set the end stop pins to input

		@board.set_pin_mode(@pin_min_x, Firmata::Board::INPUT)
		@board.set_pin_mode(@pin_min_y, Firmata::Board::INPUT)
		@board.set_pin_mode(@pin_min_z, Firmata::Board::INPUT)

		@board.set_pin_mode(@pin_max_x, Firmata::Board::INPUT)
		@board.set_pin_mode(@pin_max_y, Firmata::Board::INPUT)
		@board.set_pin_mode(@pin_max_z, Firmata::Board::INPUT)

		@board.toggle_pin_reporting(@pin_min_x)
		@board.toggle_pin_reporting(@pin_min_y)
		@board.toggle_pin_reporting(@pin_min_z)

		@board.toggle_pin_reporting(@pin_max_x)
		@board.toggle_pin_reporting(@pin_max_y)
		@board.toggle_pin_reporting(@pin_max_z)

	end


	# move the bot a number of units starting from the current position

	def moveRelative( amount_x, amount_y, amount_z)
		

		puts '**move Relative **'
		puts "x #{amount_x}"
		puts "y #{amount_y}"
		puts "z #{amount_z}"
		
		# set the direction and the enable bit for the motor drivers

		if amount_x < 0
			@board.digital_write(@pin_enb_x, Firmata::Board::LOW)
			@board.digital_write(@pin_dir_x, Firmata::Board::LOW)
		end
	
		if amount_x > 0
			@board.digital_write(@pin_enb_x, Firmata::Board::LOW)
			@board.digital_write(@pin_dir_x, Firmata::Board::HIGH)
		end

		if amount_y < 0
			@board.digital_write(@pin_enb_y, Firmata::Board::LOW)
			@board.digital_write(@pin_dir_y, Firmata::Board::LOW)
		end
	
		if amount_y > 0
			@board.digital_write(@pin_enb_y, Firmata::Board::LOW)
			@board.digital_write(@pin_dir_y, Firmata::Board::HIGH)
		end

		if amount_z < 0
			@board.digital_write(@pin_enb_z, Firmata::Board::LOW)
			@board.digital_write(@pin_dir_z, Firmata::Board::LOW)
		end
	
		if amount_z > 0
			@board.digital_write(@pin_enb_z, Firmata::Board::LOW)
			@board.digital_write(@pin_dir_z, Firmata::Board::HIGH)
		end

		# calculate the number of steps for the motors to do

		nr_steps_x = amount_x.abs * @steps_per_unit_x
		nr_steps_y = amount_y.abs * @steps_per_unit_y
		nr_steps_z = amount_z.abs * @steps_per_unit_z

		puts "x steps #{nr_steps_x}"
		puts "y steps #{nr_steps_y}"
		puts "z steps #{nr_steps_z}"

		# loop until all steps are done

		while nr_steps_x > 0 or nr_steps_y > 0 or nr_steps_z > 0 do

			# read all input pins and check the end stops

			@board.read_and_process

			#puts "x min = #{@board.pins[@pin_min_x].value} | x max = #{@board.pins[@pin_max_x].value} "
			#puts "y min = #{@board.pins[@pin_min_y].value} | y max = #{@board.pins[@pin_max_y].value} "
			#puts "z min = #{@board.pins[@pin_min_z].value} | z max = #{@board.pins[@pin_max_z].value} "

			if @board.pins[@pin_min_x].value == 1
				nr_steps_x = 0
				@pos_x = 0
				puts 'end stop min x'
			end

			if @board.pins[@pin_max_x].value == 1
				nr_steps_x = 0
				puts 'end stop max x'
			end

			if @board.pins[@pin_min_y].value == 1
				nr_steps_y = 0
				@pos_y = 0
				puts 'end stop min y'
			end

			if @board.pins[@pin_max_y].value == 1
				nr_steps_y = 0
				puts 'end stop max y'
			end

			if @board.pins[@pin_min_z].value == 1
				nr_steps_z = 0
				@pos_z = 0
				puts 'end stop min z'
			end

			if @board.pins[@pin_max_z].value == 1
				nr_steps_z = 0
				puts 'end stop max z'
			end

			# send the step pulses to the motor drivers

			if nr_steps_x > 0
				@board.digital_write(@pin_stp_x, Firmata::Board::HIGH)
				sleep 0.001
				@board.digital_write(@pin_stp_x, Firmata::Board::LOW)
				sleep 0.001
				@pos_x += 1 / @steps_per_unit_x
				nr_steps_x -= 1
			end

			if nr_steps_y > 0
				@board.digital_write(@pin_stp_y, Firmata::Board::HIGH)
				sleep 0.001
				@board.digital_write(@pin_stp_y, Firmata::Board::LOW)
				sleep 0.001
				@pos_y += 1 / @steps_per_unit_y
				nr_steps_y -= 1
	
			end
		
			if nr_steps_z > 0
				@board.digital_write(@pin_stp_z, Firmata::Board::HIGH)
				sleep 0.001
				@board.digital_write(@pin_stp_z, Firmata::Board::LOW)
				sleep 0.001
				@pos_z += 1 / @steps_per_unit_z
				nr_steps_z -= 1
			end

		end

		# disable motor drivers

		@board.digital_write(@pin_enb_x, Firmata::Board::HIGH)
		@board.digital_write(@pin_enb_y, Firmata::Board::HIGH)
		@board.digital_write(@pin_enb_z, Firmata::Board::HIGH)
			
		#while (X - pos_X).abs < 1/steps_per_unit_X

		puts '*move done*'
					
	end	
end
