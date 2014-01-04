# Abstract class with all basic functions that the farm bot can do

class FarmBotControlInterfaceAbstract

	def self.new
		raise 'abstract class cannot be instantiated'
	end
  
	def moveRelative( xAmount, yAmount, zAmount)
		raise 'function not implemented'
	end
	
	def moveRelative( xCoord, xHome, yCoord, yHome, zCoord, zHomeAmount)
		raise 'function not implemented'
	end

	def moveHome
		raise 'function not implemented'
	end
	
	def setSpeed( speed )
		raise 'function not implemented'
	end
end

