class RQC

	# @params sym: Symbol representing method to check, checks: proc contatining final conditions, constraints
	#		  tunnel?: If true, returns value of passed params, else returns random valid value
	#
	def initialize(sym, tunnel?=true, &checks)
		@method_to_check = sym
		
			
		eval("
		class #{INSERT CLASS NAME HERE}
		
			alias @method_to_check :new_call
			@MnM = 0
			
			#array of param constructors
			@gen_specs = nil
		
			def wrap_obj(obj)
				class << obj
					@FIXNUM_MAX = (2**(0.size * 8 - 2) -1)
					@FIXNUM_MIN = -(2**(0.size * 8 - 2))

					def constrain (dm = FIXNUM_MIN..FIXNUM_MAX, cs = 32..126, lndm = 0..50)
						@domain = dm
						@charset = cs						
						@len_domain = ln
					end
				end
				obj.constrain
			end
						
			def get_new_params(obj)
				retArr = []
				xxxxx = Ruber_checker::Ruby_check.new
				obj.each do |x|
					if x.class.name==\"Array\" then 
						retArr << self.get_new_params(x)
					end
					else if !x.class.name==\"Symbol\"
						return xxxxx.send(x.to_s+\"_gen\",*obj[1:obj.length-1])
					end
					else
						retArr << xxxxx.send(x.class.name+\"_gen\",x)
					end
				end
				return retArr
			end
			
			def compareReq(ret, &blk)
				@MnM++
				if #{checks}.call(ret) then
					if #{!tunnel?} then return ret end
					else return send(new_call,*prms,&blk) end
				end
				return nil
			end
			
			$ct = 0
						
			def spec_gen(arr)
				retArr = []
				arr.each do |x|
					if x.class.name==\"Array\" then 
						retArr << self.spec_gen(x)
					end
					else if !x.class.name==\"Symbol\"
					
					
					
					
					
						eval(\"$prm#{$ct}=#{x}.new\")
						eval(\"wrapObj($prm#{$ct})\")
						eval(\"retArr << $prm#{$ct}\")
						$ct++
					end
					else
						retArr << x
						$ct++
					end
				end
				@gen_specs = retArr
				return retArr
			end
			
			def spec_infer(prms)
				tempArr = []
				
				
				spec_gen(tempArr)
			end
			
			def #{@method_to_check.to_s}(*x,&blk) do
				param_new = []
				if @gen_spec.length<x.length then spec_infer(x)
				@gen_specs.each{|y| param_new << get_new_params(y)}
				ct2 = 0
				param_new.each {|z| eval(\"$p#{ct2}=z\")}
				ret = send(new_call,*param_new, &blk)
				if @MnM==0 then return self.compareReq(ret, &blk) end
				else
					@MnM--
					return ret 
				end
			end
		
		end
		")

	end
			
end






