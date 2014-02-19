
require_relative 'rqcdl'

RQC.new do
	@log = []
	lastpt = nil
	
	10.times {
		@output = sandbox("t1553",'bigadd()')
		
		#@output = sandbox("t1553",'bigflo()')
		#@output = sandbox("t1553",'divmd()')
		#handle_bigadd(false)
		puts @output
	}
	#handle_bigadd(true)
		
end

def handle_bigadd(final=false)
	if !final then
	@output.split("\n").each {|line| 
		if line.include?("<Success>") then lastpt = true
		elsif line.include?("<Error>") then lastpt = false
		elsif line.include?("[Case]") then @log << [lastpt,eval(line[6...line.length])]
		end
	} 
	else
	puts "\n\n\n"
	tru1=[]
	tru2=[]
	fal1=[]
	fal2=[]
	@log.each{|x| if x[0] then tru1<<x[1][0]; tru2<<x[1][1]; else fal1<<x[1][0]; fal2<<x[1][1];end}
	puts "True Val 1"
	puts tru1
	puts "\n\n\n\n"
	puts "True Val 2"
	puts tru2
	puts "\n\n\n\n"
	puts "False Val 1"
	puts fal1
	puts "\n\n\n\n"
	puts "False Val 2"
	puts fal2
	puts "\n\n\n\n"
	end
end