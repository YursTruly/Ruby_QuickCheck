#require 'rtc'
#require 'rtc_lib'

module Ruber_checker

#QuickCheck for Ruby
class Ruby_check

# @params obj: Object containing method, md: Method name, type: Class Object of Arg type 
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

# @params str: String name of class inheritance
# @return instance of randomly generated class
# 
def init_type(str)
	kInstance = str.split("::").inject(Object) {|parent,child| parent.const_get(child)}
	className = kInstance.class.name
	classInstance = kInstance.new
	return eval("#{className}_gen")
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

def self.Array_gen()

end

def self.Hash_gen()

end

def self.String_gen()
	tempStr = ""
	rand(50).times {tempStr += Char_gen()}
	#Fixnum_gen().times {tempStr += Char_gen()}
	return tempStr
end

def self.Symbol_gen()

end

def self.Char_gen()
	rand(32..126).chr
end

################################## Dummy Test Cases ##########################################


# Dummy test case for quicker testing purposes; Also serves as default for improper calls
#typesig("dc: (Fixnum) -> Fixnum")
def self.dc (x)
	x + 5
end

################################ Sandbox Area ###############################################

#100.times { qc(3,:+, 1.class) {|x| x>5} }
#puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#puts self.get_method(:dc)
#100.times { qc(self,:dc) {|z| z>0}}
10.times {puts String_gen()}


end

end