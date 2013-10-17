class RQC

	# Currently Handled Types
	@HANDLED_TYPES = ["String","Char","Fixnum","Float","Numeric","Symbol"]
	
	# CLIENT METHOD: Enables RQC checking of method
	# @params cls: Class containing method, sym: Symbol of method
	def route_sym(cls,sym)
		#Re-routes call to <method to check> if rqc called	
		eval("
		class #{cls}
		
			alias :new_call #{sym}
			
			def #{@method_to_check}(*x,&blk) do
				if x[0].class.name ~= \"RQC\" then
					return x[0].rqc_check(*x,&blk)
				end
				else
					return self.send(:new_call,*x,&blk)
				end
			end
		
		end
		")
	end

	# @params cls: class containing method, sym: Symbol representing method to check, 
	#		  tunnel?: If true, returns value of passed params, else returns random valid value,
	#		  &checks: block contatining final conditions
	def initialize(cls, sym, tunnel?=true, &checks)
		@method_to_check = sym.to_s
		@tunnel? = tunnel?
		@checks = &checks
				
		#array of param constructors
		@gen_specs = nil		
			
		route_sym(cls,sym)
	end
	
	@FIXNUM_MAX = (2**(0.size * 8 - 2) -1)
	@FIXNUM_MIN = -(2**(0.size * 8 - 2))
	
	# Adds constraint definitions to sample instances of objects
	def wrap_obj(obj)
		class << obj
			def constrain (dm = FIXNUM_MIN..FIXNUM_MAX, cs = 32..126, lndm = 0..50)
				@domain = dm
				@charset = cs						
				@len_domain = ln
			end
			
			def respond_to?(method)
				super.respond_to?
			end
			
			def method_missing(method, *args, &blk)
				return eval("@{method.to_s}")
			end
		end
		obj.constrain
	end
	
	# Generates random parameters										
	def get_new_params(obj)
		retArr = []
		xxxxx = Ruber_checker::Ruby_check.new
		obj.each do |x|
			if x.class.name=="Array" then 
				retArr << self.get_new_params(x)
			end
			else if !x.class.name=="Symbol"
				return xxxxx.send((x.to_s+"_gen").to_sym,*obj[1:obj.length-1])
			end
			else
				retArr << xxxxx.send((x.class.name+"_gen").to_sym,x)
			end
		end
		return retArr
	end
	
	# Check return of test case against defined checks
	def compareReq(ret, &blk)
		if @checks.call(ret) then
			if !@tunnel? then return ret end
			else return send(new_call,*prms,&blk) end
		end
		return nil
	end
		
	$ct = 0
	
	# CLIENT METHOD: Specifies input parameters								
	def spec_gen(arr)
		retArr = []
		arr.each do |x|
			if x.class.name=="Array" then 
				retArr << self.spec_gen(x)
			end
			else if !x.class.name=="Symbol"
				retArr << x.to_sym
			end
			else
				retArr << x.new
				eval("$#{@method_to_check}_prm#{$ct}=#{x}.new")
				eval("wrapObj($#{@method_to_check}_prm#{$ct})")
				eval("retArr << $#{@method_to_check}_prm#{$ct}")
				$ct++
			end
		end
		@gen_specs = retArr
		return retArr
	end
	
	# Gathers parameters for use in collecting input parameters
	def get_prms(cls)
	
	
		return nil
	end
	
	# When user passes more params than specified,
	# Infers the input types based on RTC annotations
	def spec_infer(*prms)
		tempArr = []
		prms.each{ |x|
			if HANDLED_TYPES.contains(x) then tempArr << x end
			else
				tempArr << get_prms(x)
			end
		}
		spec_gen(tempArr)
	end
	
	# Main method that handles quickcheck
	def rqc_check(*x,&blk)
		param_new = []
		if @gen_spec.length<x.length then spec_infer(x)
		@gen_specs.each{|y| param_new << get_new_params(y)}
		ct2 = 0
		param_new.each {|z| eval("$#{@method_to_check}_p#{ct2}=z"); ct2++}
		ret = send(new_call,*param_new, &blk)
		return self.compareReq(ret, &blk)
	end

=begin	
	def self.pull_rtc(obj, mthd)
	tempName = obj.new.class.name
	tempName = tempName[tempName.rindex(':')+1.. -1]
	annotatedObj = obj.new.rtc_annotate("#{tempName}")
	nominalTypeArr = (annotatedObj.rtc_typeof(mthd)).arg_types
	tempArr = []
	nominalTypeArr.each {|typ| tempArr << init_type(typ.klass.new.class.name)}
	return tempArr
	end
=end	
		
end






