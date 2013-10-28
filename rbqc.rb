require_relative "ruby_check"

class RQC
	
	# CLIENT METHOD: Enables RQC checking of method
	# @params cls: Class containing method, sym: Symbol of method
	def route_sym(cls,sym)
		#Re-routes call to <method to check> if rqc called	
		mthd_name = "new_call_#{@method_to_check}".to_sym
		
		cls.class_eval %Q"
            alias #{mthd_name} #{sym}
						
			@random_var_flag = false
			@target = self
			
			def #{@method_to_check}(*x,&blk)
				if x[0].class.name == \"RQC\" then
					prm = x[0].rqc_check(*x[1..x.size-1],&blk)
					zzz = self
					yyy = x[0].instance_variable_get(:@inst)
					@random_var_flag = x[0].instance_variable_get(:@flag)
					@target = @random_var_flag ? yyy : zzz
					p \"hi\"
					p \"#{mthd_name}\"
					ret = @target.send(#{mthd_name},*prm,&blk)
					p \"hi\"
					return x[0].compareReq(ret,@target,&blk)
				else
					return self.send(#{mthd_name},*x,&blk)
				end
			end
		"
	end
	
	def compareReq(*ret,target,&blk)
		if @checks.call(*ret) then
			return ret[0]
		end
		return nil
	end
	
	@FIXNUM_MAX = (2**(0.size * 8 - 2) -1)
	@FIXNUM_MIN = -(2**(0.size * 8 - 2))
	
	# Adds constraint definitions to sample instances of objects
	def wrap_obj(obj)
		class << obj
			def constrain (dm = @FIXNUM_MIN..@FIXNUM_MAX, cs = 32..126, lndm = 0..50)
				@domain = dm
				@charset = cs						
				@len_domain = lndm
			end
			
			def respond_to?(method)
				super.respond_to?
			end
			
			def method_missing(method, *args, &blk)
				return eval("@#{method.to_s}")
			end
		end
		obj.constrain
		return obj
	end
	
	# Generates random parameters										
	def get_new_params(obj)
		retArr = []
		xxxxx = Ruby_check.new
		obj.each do |x|
			if x.class.name=="Array" 
				retArr << self.get_new_params(x)
			elsif x.class.name=="Symbol"
				return xxxxx.send((x.to_s+"_gen").to_sym,*obj[1..(obj.size-1)])
			elsif x.class.name=="Class" and !@inst=="nil"
				return xxxxx.send((x.class.name+"_gen").to_sym,x)
			else
				retArr << xxxxx.send((x.class.name+"_gen").to_sym,x)
			end
		end
		return retArr
	end
	
	# @params cls: class containing method, sym: Symbol representing method to check,
	#		  &checks: block contatining final conditions
	def initialize(cls, sym, isObj=false, &checks)
		@cls = cls
		@method_to_check = sym.to_s
		@checks = checks
		@flag = isObj
				
		#array of param constructors
		@gen_specs = []
		
		# Currently Handled Types
		@HANDLED_TYPES = ["String","Char","Fixnum","Float","Numeric","Symbol"]
		
		@inst = "nil"
		
		route_sym(cls,sym)
	end
		
	$ct = 0
	
	# CLIENT METHOD: Specifies input parameters
	
	def spec_gen(arr)
		retArr = []
		arr.each do |x|
			if x.class.name=="Array" then 
				retArr << self.spec_gen(x)
			elsif !x.class.name=="Symbol"
				retArr << x.to_sym
			else
				xyz = x.new
				eval("$#{@method_to_check}_prm#{$ct}=xyz")
				eval("wrap_obj($#{@method_to_check}_prm#{$ct})")
				eval("retArr << $#{@method_to_check}_prm#{$ct}")
				$ct += 1
			end
		end
		@gen_specs = retArr
		return retArr
	end
	
	# Gathers parameters for use in collecting input parameters
	def get_prms(cls)
		
		
		
		return [String]
	end
	
	# When user passes more params than specified,
	# Infers the input types based on RTC annotations
	def spec_infer(*prms)
		tempArr = []
		p @HANDLED_TYPES
		prms.each{ |x|
			if @HANDLED_TYPES.include?(x) then
				tempArr << x
			else
				tempArr << get_prms(x)
			end
		}
		spec_gen(tempArr)
	end
	
	# Main method that handles quickcheck
	def rqc_check(*x,&blk)
		param_new = []
		@inst  = @flag ? get_new_params([wrap_obj(@cls.new)])[0] : "nil" 
		#p "inst #{@inst}"
		if @flag then eval("$#{@method_to_check}_p0 = @inst") end
		if @gen_specs.size<x.size then
                  spec_infer(x[0..x.size-1])
                end
		@gen_specs.each{|y| param_new << get_new_params(y)}
		ct2 = 0
		param_new.each {|z| eval("$#{@method_to_check}_p#{ct2}=z"); ct2 += 1 }
		return *param_new
	end
	
	#def get_param_refs #returns list of global parameters used


	
#	def self.pull_rtc(obj, mthd)
#	tempName = obj.new.class.name
#	tempName = tempName[tempName.rindex(':')+1.. -1]
#	annotatedObj = obj.new.rtc_annotate("#{tempName}")
#	nominalTypeArr = (annotatedObj.rtc_typeof(mthd)).arg_types
#	tempArr = []
#	nominalTypeArr.each {|typ| tempArr << init_type(typ.klass.new.class.name)}
#	return tempArr
#	end	
		
end
