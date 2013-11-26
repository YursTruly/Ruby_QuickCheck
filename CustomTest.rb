



module TestModule

	class Klass
	
			#@RQC_init = [String,Fixnum]
	
			def initialize(a,b)
				
				#b.times {p "hello, #{a}"}
				puts "initialized\n\n"
				
			end
			
			def self.mthd1(str)
				
				p str
				
			end
			
			def mthd2(fix,str)
				
				#fix.times {p str}
				5.times {p "#{str} ::::::::>>> #{fix}"}
				return true
				
			end
			
			def self.mthd3(kls)
				
				kls.mthd2(5,"This should print 5 times")
				
			end
	
	end

end