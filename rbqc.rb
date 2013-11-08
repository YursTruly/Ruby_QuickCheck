require_relative "ruby_check"

class RQC
	
	# CLIENT METHOD: Enables RQC checking of method
	# @params cls: Class containing method, sym: Symbol of method
	def route_sym(cls,sym)
		#Re-routes call to <method to check> if rqc called	
		mthd_name = "new_call_#{@method_to_check}".to_sym
		
		cls.class_eval %Q"
            alias #{mthd_name} #{sym}
			
			def #{@method_to_check}(*x,&blk)
				mname = \"#{mthd_name}\".to_sym
				random_var_flag = false
				target = self
				if x[0].class.name == \"RQC\" then
					prm = x[0].rqc_check(*x[1..x.size-1],&blk)
					zzz = self
					yyy = x[0].instance_variable_get(:@inst)
					random_var_flag = x[0].instance_variable_get(:@flag)
					target = random_var_flag ? yyy : zzz
					ret = target.send(mname,*prm,&blk)
					return x[0].compareReq(ret,target,&blk)
				else
					return self.send(mname,*x,&blk)
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
	
	# Adds constraint definitions to sample instances of objects
	def wrap_obj(obj)
		class << obj
			def rqc_constrain (dm = (-(2**(0.size * 8 - 2)))..((2**(0.size * 8 - 2) -1)), cs = 32..126, lndm = 0..50)
				@domain = dm
				@charset = cs						
				@len_domain = lndm
			end
		end
		obj.rqc_constrain
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
				return xxxxx.send((x.to_s+"_gen").to_sym,*get_new_params(obj[1..(obj.size-1)]))
			elsif x.class.name=="Class" and !@inst=="nil"
				return xxxxx.send((x.to_s+"_gen").to_sym,x)
			else
				retArr << xxxxx.send((x.to_s+"_gen").to_sym,x)
			end
		end
		return retArr
	end
	
	# @params cls: class containing method, sym: Symbol representing method to check,
	#		  isObj: Does the object from which method is called be generated?, &checks: block contatining final conditions
	def initialize(cls, sym, isObj=true, &checks)
		@cls = cls
		@cls_def = []
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
	
	def spec_gen(arr=[], cls_def2=[@cls])
		if !cls_def2.nil? then 
			@cls_def = spec_gen(cls_def2, nil)
		end
		retArr = []
		arr.each do |x|
			if x.class.name=="Array" then 
				retArr << self.spec_gen(x)
			elsif x.class.name=="Symbol"
				retArr << x
			else
				eval("$#{@method_to_check}_c#{$ct}=wrap_obj(x.to_s)")
				eval("retArr << $#{@method_to_check}_c#{$ct}")
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
				tempArr << x.class
			else
				tempArr << get_prms(x.class)
			end
		}
		spec_gen(tempArr)
	end
	
	# Main method that handles quickcheck
	def rqc_check(*x,&blk)
		param_new = []
		if @cls_def.size==0 then
			spec_gen([]) 
		end
		if @gen_specs.size<x.size then spec_infer(x[0..x.size-1]) end
		if @flag then 
			@inst = get_new_params(@cls_def)[0]
			eval("$#{@method_to_check}_p0 = @inst") 
		end
		param_new = get_new_params(@gen_specs)
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
