require_relative "ruby_check"

class RQC

	$prm_generators = []
	
	#def initialize(*prms)
	#	$prm_generators = set_gen(*prms)
	#end
	
	def RQC.qc(*prms,&checks)
		srand
		if !prms.empty? then $prm_generators = set_gen(*prms) end
		if &checks.nil? then return end
		prm_generators = $prm_generators
		tempPrms = []
		prm_generators.each {|x| rand(x.instance_variable_get(:@splat_range)).times{tempPrms << x.gen}}
		if !checks.call(*tempPrms) then raise "RQC Test Failed on Test Case: #{tempPrms}" else p "Passed: #{tempPrms}" end
	end
	
	def RQC.set_gen(*prms)
		tempArr = []
		#p prms
		prms.each {|x| tempArr << (x.is_a?(String.class) ? RQC_gen.new(x):RQC_gen.new(x[0],*(set_gen(*(x[1...x.length])))))}
		return tempArr
	end
	
end

class RQC_gen
	
	srand
	@@HANDLED_TYPES = {"String" => "tempStr=\"\";rand(@len_domain).times{tempStr +=eval(@@HANDLED_TYPES[\"Char\"])};tempStr",
	"Char" => "if @charset.class==Range then rand(@charset).chr else @charset.sample end",
	"Fixnum" => "rand(@domain)",
	"Float" => "rand()*eval(@@HANDLED_TYPES[\"Fixnum\"])",
	"Numeric" => "str=rand(0..1)>0 ? \"Float\":\"Fixnum\"; eval(@@HANDLED_TYPES[str])",
	"Symbol" => "eval(@@HANDLED_TYPES[\"String\"]).to_sym"
	}

	def initialize(typ,*prms)
		@cls = typ
		@splat_range = 1..1
		@domain = (-(2**(0.size * 8 - 2)))..((2**(0.size * 8 - 2) -1))
		@charset = 32..126						
		@len_domain = 0..50
		@prms = prms
		prc = "p \"Generation Method Not Implemented\""
		if @@HANDLED_TYPES.has_key?(typ.to_s) then 
			prc = @@HANDLED_TYPES[typ.to_s]
		elsif !prms.empty?
			prc = "prm=[];@prms.each{|x| prm<<x.gen};@cls.new(*prm)"
		end
		@prc = prc
	end
	
	def gen()
		return eval(@prc)
	end
		
end