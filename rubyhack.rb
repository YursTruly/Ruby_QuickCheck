require 'delegate'


def hi(x) #x can be Numeric or String
	y = x*5
	if x then p "hi" end
	if x < 8 then y =  x+x+1 else y = x+7 end
	x = 5
	return x 
end

#obj = BasicObject.new
#class << obj
#	def method_missing(name, *args, &blk)
#		return name
#	end
#end

#p obj+1
class RQC
def self.blank(x)
	eval("
	obj = BasicObject.new
	class << obj
		def method_missing(name, *args, &blk)
			if @questlog.nil? then @questlog = [] end
			@questlog << [name,args]
			return #{x.inspect}.send(name, *args, &blk)
		end
		def rqc_get()
			return @questlog
		end
	end
	return obj
	")
end
end

test = RQC.blank(5) #cannot handle if x is redefined i.e. x = x+1
#p test.methods
ttt =  hi(test)
#p ttt
p test.rqc_get
puts "\n\n"

#possible: use state-based recording

def hi2()
	$x = 5+3
	x = $x+1
end

puts RubyVM::InstructionSequence.disasm(method(:hi2))