require 'rtc_lib'

module Ruber_checker

class Ruby_check

# Currently Handled Types
HANDLED_TYPES = ["String","Char","Fixnum","Float","Array","Hash","Numeric"]

# Constants for random generation
srand
@FIXNUM_MAX = (2**(0.size * 8 - 2) -1)
@FIXNUM_MIN = -(2**(0.size * 8 - 2))

# Generators for handled types
def self.Fixnum_gen(obj)
	return rand(obj.instance_variable_get(:@domain))
end

def self.Float_gen(obj)
	return rand() * Fixnum_gen(obj)
end

def self.Char_gen(obj)
	return rand(obj.instance_variable_get(:@charset)).chr
end

def self.String_gen(obj)
	tempStr = ""
	rand(obj.instance_variable_get(:@len__domain)).times {tempStr += Char_gen(obj)}
	return tempStr
end

def self.Numeric_gen(obj)
	case rand(2)
		when 0 then return Fixnum_gen(obj)
		when 1 then return Float_gen(obj)
	end
end

def self.Symbol_gen(obj)
	return String_gen(obj).to_sym
end

#Method_gen()

def method_missing(*x, &blk)
	
	
	
	
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

# @params obj: Class, mthd: Method to test, id: OPT! Avoid annotation override
# @return Array of parameter types
#
def self.pull_rtc(obj, mthd)
	tempName = obj.new.class.name
	tempName = tempName[tempName.rindex(':')+1.. -1]
	annotatedObj = obj.new.rtc_annotate("#{tempName}")
	nominalTypeArr = (annotatedObj.rtc_typeof(mthd)).arg_types
	tempArr = []
	nominalTypeArr.each {|typ| tempArr << init_type(typ.klass.new.class.name)}
	return tempArr
end

#############################################################################################
################################ Sandbox Area ###############################################
#############################################################################################

#100.times { qc(3,:+, 1.class) {|x| x>5} }
#puts self.get_method(:dc)
#100.times { qc(self,:dc) {|z| z>0}}
#10.times {puts String_gen()}
#20.times {Array_gen(false, false, 1, "no", 'x')}

#arr = [1,2,3,4,5]
#nnn = ::Ruber_checker::Rndm.new(0,"hi",arr)
#puts Custom_gen(nnn.class.name, 0, "hi", arr).to_s

#Ruby_check.printArr( Ruby_check.pull_rtc(Ruby_check,:dc))

end