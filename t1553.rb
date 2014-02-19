
#9246
def bigadd ()
	require 'bigdecimal'
	require_relative 'rqcdl'
		
	RQC.new do
		fx = restr(make(Fixnum),:@domain,(-1000000..1000000))
		10.times {
			#qc(fx,fx) {|x,y| BigDecimal("1E"+x.to_s)+BigDecimal(y)} 
			qc(Fixnum,Fixnum) {|x,y| BigDecimal("1E"+x.to_s)+BigDecimal(y)} 
		}
	end
end

#9192
def bigflo()
	require 'bigdecimal'
	require_relative 'rqcdl'
	
	RQC.new do
		op = { :== => :==, :< => :>, :> => :<, :<= => :>=, :>= => :<= }
		qc(restr(make([Float, Fixnum]),:@domain, -500..500)) {|x| tf = true; d=BigDecimal(x); f = x.to_f;
			p f; p d;
			op.each {|oper, inv| if d.send(oper,f)^f.send(inv,d) then tf = false end}; tf
		}
	end
end

#7699
def divmd()
	require 'bigdecimal'
	require_relative 'rqcdl'
	
	RQC.new do
		num = make(BigDecimal, Fixnum)
		qc(Fixnum,num) {|a,b| a=BigDecimal("1E"+a.to_s); q,m=a.divmod(b); a==q*b+m}
	end
end