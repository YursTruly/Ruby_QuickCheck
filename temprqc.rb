require_relative "ruby_check"

class RQC
	
	srand
	@prm_generators = []
	
	def initialize(*prms)
		@prm_generators = set_gen(*prms)
	end
	
	def qc(*prms=[],&checks)
		if !prms.empty? then @prm_generators = set_gen(*prms) end
		tempPrms = []
		@prm_generators.each {|x| tempPrms << x.gen}
		if !checks.call(*tempPrms) raise "RQC Test Failed on Test Case: #{tempPrms}" end
	end
	
	def set_gen(*prms)
		tempArr = []
		prms.each {|x| rand(x.instance_variable_get(:@splat_range)).times
		{tempArr << x.is_a?(Class) ? RQC_gen.new(x):RQC_gen(set_gen(x[1..x.length-1]))}}
	end
	
end

class RQC_gen
	
	srand
	@HANDLED_TYPES = {"String" => Proc.new{tempStr="";rand(@len_domain).times{tempStr +=@HANDLED_TYPES["Char"].call};tempStr}
					,"Char" => Proc.new{rand(@charset).chr}
					,"Fixnum" => Proc.new{rand(@domain)}
					,"Float" => Proc.new{rand()*@HANDLED_TYPES["Fixnum"].call}
					,"Numeric" => Proc.new{str=rand(0..1)>0 ? "Float":"Fixnum"; @HANDLED_TYPES[str].call}
					,"Symbol" => Proc.new{@HANDLED_TYPES["String"].call.to_sym}
					}
	@splat_range = 1..1
	@cls = Class
	@domain = (-(2**(0.size * 8 - 2)))..((2**(0.size * 8 - 2) -1))
	@charset = 32..126						
	@len_domain = 0..50

	def initialize(typ,*prms=[])
		@cls = typ
		prc = Proc.new{p "Generation Method Not Implemented"}
		if @HANDLED_TYPES.has_key?(typ.to_s) then 
			prc = @HANDLED_TYPES[typ.to_s]
		elsif !prms.empty?
			prc = Proc.new{prm=[];prms.each{|x| prm<<x.gen};@cls.new(*prm)}
		end
		self.send(:define_Method,:gen,prc)
	end
		
end