require 'rtc_lib'

module Ruber_checker

#Dummy Class for Testing
class Rndm

	def initialize(x, y, z)
		@x = x
		@y = y
		@z = z
		puts "\n\nINITIALIZED!\n\n"
	end

	def to_s()
		return "YAY!\n\nx:#{@x} y:#{@y} z:#{@z}"
	end

end


class Ruby_check
	rtc_annotated

# Currently Handled Types
HANDLED_TYPES = ["String","Char","Fixnum","Float","Array","Hash"]

# @param obj: Object containing method, md: Method name, type: Class Object of Arg type 
# @return array of test_set with test results
# Handles case testing
def self.qc (obj, md) #type* handler
	#puts type.name
	puts "Inside QC Loop"
	x = Fixnum_gen
	ret = obj.send(md, x)
	if not (yield ret)
		raise "Failed! #{x}"
	end
end

# @param className: Class name, obj: Sample instance of object to create
# @return instance of randomly generated class
# 
def self.init_type(className, obj=nil)
	if !HANDLED_TYPES.index(className) then return Custom_gen(className, obj) end
	if obj.class.name == "Array" then return Array_gen(false, false, obj) end
	return eval("self.#{className}_gen()")
end

# Constants for random generation
srand
FIXNUM_MAX = (2**(0.size * 8 - 2) -1)
FIXNUM_MIN = -(2**(0.size * 8 - 2))

# Generators for handled types
def self.Fixnum_gen()
	rand(FIXNUM_MAX) * (if rand(2)==1 then -1 else 1 end)
end

def self.Float_gen()
	rand() * Fixnum_gen()
end

def self.Char_gen()
	rand(32..126).chr
end

def self.String_gen()
	tempStr = ""
	rand(50).times {tempStr += Char_gen()}
	return tempStr
end

def self.Numeric_gen()

end

def self.Symbol_gen()

end

# @param fixedLen: False or designated length, ordered: If types given in specific order,
#		 *types: Array sample
def self.Array_gen(fixedLen, ordered, types)
	tempArr = []
	if ordered then types.each {|type| tempArr << init_type(type.class.name)}
	elsif fixedLen then fixedLen.times { tempArr << init_type(types[rand(types.length)].class.name)}
	else rand(50).times { tempArr << init_type(types[rand(types.length)].class.name) }
	end
	return tempArr
end

def self.Hash_gen()

end

def self.Method_gen()

end

#!!!!!!!!!!!!!!!!!!!!!!! FILE POINTER ISSUE

#@param className: String name of class, *prm: Sample parameters of class constructor
def self.Custom_gen(className, *prm)
	kInstance = className.split('::').inject(Object) {|parent,child| parent.const_get(child)}
	paramArr = []
	prm.each{|tempObj| paramArr << init_type(tempObj.class.name, tempObj)}
	printArr(paramArr, "custom gen param arr")
	return kInstance.new(*paramArr)
end

# @params obj: Class instance, mthd: Method to test, id: OPT! Avoid annotation override
# @return Array of parameter types
#
def self.pull_rtc(obj, mthd)
	tempName = obj.new.class.name
	tempName = tempName[tempName.rindex(':')+1.. -1]
	annotatedObj = obj.new.rtc_annotate("#{tempName}")
	nominalTypeArr = (annotatedObj.rtc_typeof(mthd)).arg_types
	tempArr = []
	nominalTypeArr.each {|typ| tempArr << typ.klass.new.class.name}
	#Stack depth reached error if return initialized types!!
	return tempArr
end

########################################## Tools ############################################


# @param val: Value to clamp, max: Max acceptable value, min: Min acceptable value
# @return Object of same type as val that fits constraints
# Checks for user constraint compliance
def self.clampNumber(val, max = FIXNUM_MAX, min = FIXNUM_MIN)
	x = val
	if x>max then x = max end
	if x<min then x = min end
	return x
end

def self.printArr(tempArr, note = "")
	print "\n\nPRINT ARR: #{note} ["
	tempArr.each {|x| if x.class.name == "Array" then printArr(x) else print "#{x}, " end}
	print "]\n\n"
end

# 
# 
# does nothing atm
def self.forwardInit(method, *params)
	
end

################################## Dummy Test Cases ##########################################


# Dummy test case for quicker testing purposes 
typesig('dc: (Numeric, String) -> String')
def self.dc (x, y)
	z = ""
	x.times {z += y}
	return z
end

################################ Sandbox Area ###############################################

#100.times { qc(3,:+, 1.class) {|x| x>5} }
#puts self.get_method(:dc)
#100.times { qc(self,:dc) {|z| z>0}}
#10.times {puts String_gen()}
#20.times {Array_gen(false, false, 1, "no", 'x')}

#arr = [1,2,3,4,5]
#nnn = ::Ruber_checker::Rndm.new(0,"hi",arr)
#puts Custom_gen(nnn.class.name, 0, "hi", arr).to_s

x = pull_rtc(self,:dc)
tempArr = []
x.each {|z| tempArr << init_type(z)}
#/Users/alextyu/.rvm/gems/ruby-1.9.3-p448/gems/rtc-0.0.0/lib/rtc/proxy_object.rb:159: stack level too deep (SystemStackError)

end

end