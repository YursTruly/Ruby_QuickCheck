#@author Phrogz
class Integer
 @@happysteps = Hash.new{ |k,v| k[v] = {} }
 def happy?( base=10 )
  seen = {}
  num = self
  until num==1 or seen[ num ]
   seen[ num ] = true
   num = num.to_s(base).split('').map{ |c| c.to_i(base)**2 }.inject{
|s,i| s+i }
  end
  num == 1
 end
end

happy = Hash.new{ |h1,base|
 h1[ base ] = Hash.new{ |h2, n|
  if n == 1
   h2[ 1 ] = true
  else
   h2[ n ] = :not_happy
   sum_of_squares = n.to_s(base).split('').map{ |c| c.to_i(base)**2
}.inject{ |s,i| s+i }
   if sum_of_squares == 1
    h2[ n ] = true
   else
    subn = h2[ sum_of_squares ]
    if subn == true
     h2[ n ] = true
    elsif subn == false || subn == :not_happy
     h2[ n ] = h2[ sum_of_squares ] = false
    end
   end
  end
 }
}
#test
require_relative "rqc"
#RubyQuiz 93
prc2 = Proc.new {
|x|
tempArr = []
until x<=0 do tempArr << (x%10)**2; x=x/10 end
sum=0
for i in 0...(tempArr.size) do sum +=tempArr[i] end
if sum==1 then true else prc2.call(sum) end
}
RQC.qc(Fixnum)
$prm_generators[0].instance_variable_set(:@domain, 0..((2**(0.size * 8 - 2) -1)))
#100.times {RQC.qc {|fix| if fix.happy? then if prc2.call(fix) then p "#{fix}" else false end else true end}}
10.times {RQC.qc {|fix| begin x=false;prc.call(fix);x=true; rescue x==fix.happy?; end}}
