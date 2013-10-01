
module CSP

	class Arc
	
		# @params varName: name of variable, constr: Constraint on variable
		# @return Instantiates Arc object holding a constraint and an associated variable
		#         as well as priority value for solving
		def self.initialize(varName, constr)
			@VAR = varName
			@CONSTR = constr
			@PRIO = detPrio()
		end
		
		
		# @return A Fixnum representation of solving priority
		def self.detPrio()
			tempArr = []
			#implementation here
			
		end
	
	end
	
	class MAC
		
		# @return Array of variables used in String
		def String.getVars()
			
			#some syntax or parsing implementation
			return []
			
		end
		
		# @params 
		# @returns nil; Modifies the domain of one variable
		def self.prune()
		
		end
		
		def getMin()
		
		end
		
		def getMax()
		
		end
		
		# @params constr: Set of constraints as strings
		# @return Arc consistent domains for each variable
		# Computes binary arc consistency
		def self.ac (constr)
			
			#Set up arcs
			arcArr = []
			constr.each {|y| y.getVars.each {
				|x| x.dom = {getMin(self.class.name)..getMax(self.class.name)}
				arcArr << new Arc(x,y) } }
			
			#Compare arcs
			arcArr.each do
			
				
			
			end
			
		end
			
	end

end