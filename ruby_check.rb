#require 'rtc'
#require 'rtc_lib'

module Ruber_checker

#Dummy Class for Testing
class Rndm

def initialize(x, y, z)
	@x = x
	@y = y
	@z = z
end

def to_s()
	return "x:#{@x} y:#{@y} z:#{@z}"
end

end


#QuickCheck for Ruby
class Ruby_check
	#rtc_annotated

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
def self.init_type(className, obj)
	if !isHandled(className) then return Custom_gen() end #params in custom gen
	kInstance = className.split('::').inject(Object) {|parent,child| parent.const_get(child)}
	#classInstance = kInstance.new
	tempObj = ""
	if obj.class.name == "Array" then tempObj = obj end
	return eval("self.#{className}_gen(#{tempObj})")
end

# @param name: Class name of ohject in question
# @return Boolean: Whether param is supported type
# Determines if class name is handled by this program
def self.isHandled(name)
	return HANDLED_TYPES.index(name)
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
	#Fixnum_gen().times {tempStr += Char_gen()}
	return tempStr
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
	printArr(tempArr)
	return tempArr
end

def self.Hash_gen()

end

#!!!!!!!!!!!!!!!!!!!!!!! FILE POINTER ISSUE

#@param className: String name of class, *prm: Sample parameters of class constructor
def self.Custom_gen(className, *prm)
	kInstance = className.split('::').inject(Object) {|parent,child| parent.const_get(child)}
	tempStr2 = "kInstance.new("
	prm.each {|typ| 
	arrVar = ""
	if typ.class.name == "Array" then arrVar = ",#{typ}" end
	tempStr2 += "init_type(#{typ.class.name}#{arrVar}),"}
	tempStr2.chop!
	tempStr2 +=")"
	puts "TEMPSTR2: #{tempStr2}"
	puts "kInstance: #{kInstance}"
	return eval(tempStr2) 
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

def self.printArr(tempArr)
	print "\n\n\nPRINT ARR: ["
	tempArr.each {|x| if x.class.name == "Array" then printArr(x) else print "#{x}, " end}
	print "]\n\n\n"
end

# 
# 
# does nothing atm
def self.forwardInit(method, *params)
	
end

################################## Dummy Test Cases ##########################################


# Dummy test case for quicker testing purposes 
#typesig('dc: (Numeric) -> Numeric')
def self.dc (x)
	x + 5
end

################################ Sandbox Area ###############################################

#100.times { qc(3,:+, 1.class) {|x| x>5} }
#puts self.get_method(:dc)
#100.times { qc(self,:dc) {|z| z>0}}
#10.times {puts String_gen()}
#20.times {Array_gen(false, false, 1, "no", 'x')}
arr = [1,2,3,4,5]
nnn = ::Ruber_checker::Rndm.new(0,"hi",arr)
puts Custom_gen(nnn.class.name, 0, "hi", arr).to_s

end

end