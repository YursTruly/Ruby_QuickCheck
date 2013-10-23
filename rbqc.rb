require_relative "ruby_check"

class RQC
	
	# CLIENT METHOD: Enables RQC checking of method
	# @params cls: Class containing method, sym: Symbol of method
	def route_sym(cls,sym)
          #Re-routes call to <method to check> if rqc called	
          cls.class_eval("
            alias :new_call #{sym}
			
            def #{@method_to_check}(*x,&blk)
				if x[0].class.name == \"RQC\" then
					return x[0].compareReq(#{@inst ? @inst : self}.send(:new_call,x[0].rqc_check(*x[1..x.size-1],&blk),&blk),&blk)
				else
					return self.send(:new_call,*x,&blk)
				end
			end
		  ")
	end

	# @params cls: class containing method, sym: Symbol representing method to check, 
	#		  tunnel?: If true, returns value of passed params, else returns random valid value,
	#		  &checks: block contatining final conditions
	def initialize(cls, sym, isObj=false, tunnel=true, &checks)
		@method_to_check = sym.to_s
		@tunnel = tunnel
		@checks = checks
		@flag = isObj
				
		#array of param constructors
		@gen_specs = nil
		
		# Currently Handled Types
		@HANDLED_TYPES = ["String","Char","Fixnum","Float","Numeric","Symbol"]
		
		route_sym(cls,sym)
	end
	
	FIXNUM_MAX = (2**(0.size * 8 - 2) -1)
	FIXNUM_MIN = -(2**(0.size * 8 - 2))
	
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
				return eval("@#{method.to_s}")
			end
		end
		obj.constrain
	end
	
	# Generates random parameters										
	def get_new_params(obj)
		retArr = []
		xxxxx = Ruby_check.new
		obj.each do |x|
			if x.class.name=="Array" 
				retArr << self.get_new_params(x)
			elsif !x.class.name=="Symbol"
				return xxxxx.send((x.to_s+"_gen").to_sym,*obj[1..(obj.size-1)])
			else
				retArr << xxxxx.send((x.class.name+"_gen").to_sym,x)
			end
		end
		return retArr
	end
	
	# Check return of test case against defined checks
	def compareReq(ret, &blk)
		if @checks.call(ret) then
                  if !@tunnel then
                    return ret
                  else
                    return send(new_call,*prms,&blk)
                  end
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
		
		
		
		return nil
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
		@inst  = @flag ? get_new_params([cls.new])[0] : nil 
		if @gen_specs.size<x.size then
                  spec_infer(x[0..x.size-1])
                end
		@gen_specs.each{|y| param_new << get_new_params(y)}
		ct2 = 0
		param_new.each {|z| eval("$#{@method_to_check}_p#{ct2}=z"); ct2 += 1 }
		return *param_new
	end
	
	#def get_param_refs #returns list of global parameters used


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
