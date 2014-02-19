class RQC

	def initialize (&blk)
		@rpt = []
		self.instance_eval &blk
	end
	
	def make (klass, *prms)
		#RQC_generator.blank(RQC_generator.new(klass, *prms))
		RQC_generator.new(klass, *prms)
	end
	
	def addvar (obj, var, val)
		#ensure @
		obj.instance_variable_set(var, val)
		obj
	end
	
	def addklass (obj, *klasses)
		varls = obj.instance_variable_get(:@cls)
		klasses.each {|kls| varls << RQC_generator.new(kls)}
		obj
	end
	
	def restr (obj, sym, val)
		obj.instance_variable_set(sym,val)
		obj
	end
		
	def report (obj,sym)
		@rpt << [obj,sym]
	end
	 
	def enforce (&blk)
		@post = blk
	end
	
	require 'rbconfig'
	require 'shell'
	rby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
	Shell.def_system_command :ruby, rby
	def sandbox(fname, mthd='foo()')
		#$argv
		$stdout.sync = true
		thisfile = File.dirname(File.expand_path(__FILE__))+"/#{fname}"
		shell = Shell.new
		process = shell.transact do ruby('-r', thisfile, '-e', mthd) end
		output = process.to_s
		return output
		#output.split("\n").each do |line|
		#	puts line
		#end
	end
	
	def qc (*gens)
		srand
		if !block_given? then return end
		tempPrms = []
		gens.each{|genr| tempPrms << RQC_generator.new(genr).gen}
		begin
			chk = yield(*tempPrms)
		rescue
			chk = nil
		ensure
			tf = chk ? "Success":"Error"
			puts "<#{tf}>\n[Result]#{chk}\n[Case]#{tempPrms}\n\n"
			@rpt.each {|rptcase| rptcase[0].send(rptcase[1],chk,*tempPrms)}
			if (not @post.nil?) then @post.call end
		end
		tempPrms
	end

end

class RQC_generator
	srand
	@@HANDLED_TYPES = {"String" => "tempStr=\"\";rand(@len_domain).times{tempStr +=eval(@@HANDLED_TYPES[\"Char\"])};tempStr",
	"Char" => "if @charset.class==Range then rand(@charset).chr else @charset.sample end",
	"Fixnum" => "rand(@domain)",
	"Float" => "rand()*eval(@@HANDLED_TYPES[\"Fixnum\"])",
	"Numeric" => "str=rand(0..1)>0 ? \"Float\":\"Fixnum\"; eval(@@HANDLED_TYPES[str])",
	"Symbol" => "eval(@@HANDLED_TYPES[\"String\"]).to_sym",
	"TrueClass" => "rand(0..1)>0",
	"FalseClass" => "rand(0..1)<1"
	}

	def initialize(typ,*prms)
		if typ.instance_of? RQC_generator 
		then 
			typ.instance_variables.each{|x| self.instance_variable_set(x,typ.instance_variable_get(x))}
			return self 
		end
		@cls = typ.class==Array ? typ:[typ]
		@splat_range = 1..1
		@domain = (-(2**(0.size * 8 - 2)))..((2**(0.size * 8 - 2) -1))
		@charset = 32..126						
		@len_domain = 0..50
		prm = []
		prms.each{|x| prm << RQC_generator.new(x)}
		@prms = prm
		@instvars = [] #[[]]
		@custom_prc = nil
	end
	
	def get_vars()
		@instvars
	end
	
	def self.blank(x)
	eval("
		obj = BasicObject.new
		class << obj
			def method_missing(name, *args, &blk)
				if @questlog.nil? then @questlog = [] end
				@questlog << [name,@rqcval,args]
				@rqcval = #{x.inspect}.send(name, *args, &blk)
				return @rqcval
			end
			def rqc_get()
				return @questlog
			end
			def inspect()
				return @rqcval
			end
		end
		return obj
		")
	end
	
	def gen()
		typ = @cls[rand(0...@cls.length)]
		prc = "p \"Generation Method Not Implemented\""
		if @@HANDLED_TYPES.has_key?(typ.to_s) then 
			prc = @@HANDLED_TYPES[typ.to_s]
		elsif !@prms.empty?
			prc = "prm=[];@prms.each{|x| prm<<x.gen};typ.new(*prm)"
		end
		@prc = prc
		if !@custom_prc.nil? then @custom_prc.call(@prc)
		else
			tmp = eval(@prc)
			#ensure trailing @ for insta vars
			@instvars.each{|x| tmp.set_instance_variable(x[0].to_sym,x[1].gen)}
			return tmp
		end
	end
end