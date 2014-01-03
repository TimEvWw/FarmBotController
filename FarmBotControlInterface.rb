# Abstract class with all basic functions that the farm bot can do

class FarmBotControlInterfaceAbstract

	def self.new
		raise 'abstract class cannot be instantiated'
	end
  
	def moveTo( X, Y, Z )
		raise 'function not implemented'
	end
	
	def moveHome
		raise 'function not implemented'
	end
	
	def setSpeed( speed )
		raise 'function not implemented'
	end
end

