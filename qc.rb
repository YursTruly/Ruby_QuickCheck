require 'rdl'

class QC < Object
	extend RDL
	
	keyword :qc do
		
		#puts "hi#{x}"
		@num_cases = 100
		
				
		dsl do
		
			keyword :params do
			
				dsl do
					
					keyword :'=' do
						action{|*x| puts "====="}
					end
					
				end
			
			end
			
			keyword :constrain do
				#Set generation constraints
					
				dsl do
					
					keyword :from do
						action{|*x| puts "from"}
					end
					
					keyword :to do
						action{|*x| puts "to"}
					end
						
					keyword :with do
						action{|*x| puts "with"}
					end
						
				end
				
				pre_task { |*x| puts "pre" }
				
				post_task { |*x| puts "post" }
			
			end
							
			keyword :check do
				#Set post conditions to check
				action{|*y| puts y}
			end
				
			keyword :times do
				action{|*x| @num_cases = x}
				post_task{|*x| puts @num_cases}
			end
			
		end
		
		pre_task{|msym,*prm,&blk|
			@prms = *prm
		}
		
		post_task{|msym,*prm,&blk|
			num_cases.times {
				tmprm = nil#call qc generators
				self.send(msym, tmprm)
			}	
		}

	end
end


#m = QC.instance_method(:qc)
#p m.parameters

a = QC.new
#a.qc("hello","hi") {constrain("hello") {from "j"; to "k"}; times 5}
a.qc("hi") {params {:y=8}}










