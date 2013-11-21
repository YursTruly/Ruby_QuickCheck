



module TestModule

	class Klass
	
			#@RQC_init = [String,Fixnum]
	
			def self.initialize()#a,b)
				
				#b.times {p "hello, #{a}"}
				#p "initialized\n\n"
				
			end
			
			def self.mthd1(str)
				
				p str
				
			end
			
			def self.mthd2(fix,str)
				
				fix.times {p str}
				
			end
			
			def self.mthd3(kls)
				
				kls.mthd2(5,"This should print 5 times")
				
			end
	
	end

end