class RQC

	# @params sym: Symbol representing method to check, *prms: Symbols as alternate names for parameters
	#		  checks: proc contatining final conditions, constraints
	#		  tunnel?: If true, returns value of passed params, else returns random valid value
	#
	def initialize(sym, *prms=nil, checks=new Proc {|x| x==x}, constraints=new Proc {|x| x==x}, tunnel?=true)
		@method_to_check = sym
		@names = prms #for each name provided around method
		@cmd = &blk
		
			
		eval("
		class #{INSERT CLASS NAME HERE}
		
			alias @method_to_check :new_call
			@MnM = 0
		
			def get_wrapped_obj(obj)
				class << obj
					def leaf3 ()
						switch (obj.class.name)
							when \"String\" do
							
							end
							when \"Fixnum\" do
							
							end
							
							else do
							
							end
						end						
					end
				end
				obj.leaf3
				xxxxx = Ruber_checker::Ruby_check.new
				return xxxxx.send(obj.class.name.to_sym, obj)
			end
			
			def compareReq(ret, &blk)
				@MnM++
				if #{checks}.call(ret) then
				 if !tunnel? then return ret end
				 else return send(new_call,*prms,&blk) end
				end
				return nil
			end
		
			def #{@method_to_check.to_s}(*x,&blk) do
				param_new = []
				x.each{|y| param_new << get_wrapped_obj(y)}
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