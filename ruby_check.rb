#require 'rtc'
#require 'rtc_lib'

module Ruber_checker

#QuickCheck for Ruby
class Ruby_check  

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

# @param str: Class object
# @return instance of randomly generated class
# 
def self.init_type(cls)
	className = cls.name
	if !isHandled(className) then return Custom_gen() end #params in custom gen
	kInstance = className.split('::').inject(Object) {|parent,child| parent.const_get(child)}
	#classInstance = kInstance.new
	return eval("self.#{className}_gen()")
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
#		 *types: Array types
def self.Array_gen(fixedLen, ordered, *types)
	tempArr = []
	if ordered then types.each {|type| tempArr << init_type(type.class.name)}
	elsif fixedLen then fixedLen.times { tempArr << init_type(types[rand(types.length)])}
	else rand(50).times { tempArr << init_type(types[rand(types.length)]) }
	end
	print "TEMPARR: ["
	tempArr.each {|x| print "#{x}, "}
	print "]\n\n\n"
	return tempArr
end

def self.Hash_gen()

end

#!!!!!!!!!!!!!!!!!!!!!!! FILE POINTER ISSUE

#@param className: String name of class, *params: Sample parameters of class constructor
def self.Custom_gen(className, *params)
	kInstance = className.split('::').inject(Object) {|parent,child| parent.const_get(child)}
	return kInstance.new(params.each {|typ| init_type(typ.class)}) 
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

# 
# 
# does nothing atm
def self.forwardInit(method, *params)
	
end

################################## Dummy Test Cases ##########################################


# Dummy test case for quicker testing purposes 
#typesig("dc: (Fixnum) -> Fixnum")
def self.dc (x)
	x + 5
end

################################ Sandbox Area ###############################################

#100.times { qc(3,:+, 1.class) {|x| x>5} }
#puts self.get_method(:dc)
#100.times { qc(self,:dc) {|z| z>0}}
#10.times {puts String_gen()}
#20.times {Array_gen(false, false, 1.class, "no".class, 'x'.class)}


end

end