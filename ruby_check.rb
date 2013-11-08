#require 'rtc_lib'

class Ruby_check

	srand
	
	# Generators for handled types
	# @params obj: Sample object with constraints bound to eigenclass
	def Fixnum_gen(obj)
		return rand(obj.instance_variable_get(:@domain))
	end

	def Float_gen(obj)
		return rand() * Fixnum_gen(obj)
	end

	def Char_gen(obj)
		return rand(obj.instance_variable_get(:@charset)).chr
	end

	def String_gen(obj)
		tempStr = ""
		rand(obj.instance_variable_get(:@len_domain)).times {tempStr += Char_gen(obj)}
		return tempStr
	end

	def Numeric_gen(obj)
		case rand(2)
			when 0 then return Fixnum_gen(obj)
			when 1 then return Float_gen(obj)
		end
	end

	def Symbol_gen(obj)
		return String_gen(obj).to_sym
	end
	
	def respond_to?(method)
		super.respond_to?
	end

	# Handles generators for user-defined or non-primitive types	
	def method_missing(method, sym, *x, &blk)
		kInstance = sym.to_s.split('::').inject(Object) {|parent,child| parent.const_get(child)}
		return kInstance.new(*x,&blk)
	end

end