 # William Henderson-Frost
 # Ruby-Quiz 93

 # This solution works for base ten numbers.
 # I look forward to seeing how others handle the different bases.
 # (googolplex ** googolplex) is a happy number =D

 class Integer

   def happy?
     n, found = self, []
     loop do
       found << n ; next_n = 0
       n.to_s.scan(/./) { |i| next_n += i.to_i**2 } ; n = next_n
       return found if n == 1
       return false if found.index(n)
     end
   end

   def Integer.happiest(limit)
     num = 1
     (1..limit).each { |n| num = n if n.happy? and n.happy?.size >  
 num.happy?.size }
     num
   end

 end

#test
require_relative "rqc"
#RubyQuiz 93
$memx=[]
prc2 = Proc.new {
|x|
tempArr = []
until x<=0 do tempArr << (x%10)**2; x=x/10 end
sum=0
for i in 0...(tempArr.size) do sum +=tempArr[i] end
if sum==1 then $memx=[];true elsif $memx.include?(sum) then false else $memx<<sum;prc2.call(sum) end
}
RQC.qc(Fixnum)
$prm_generators[0].instance_variable_set(:@domain, 0..((2**(0.size * 8 - 2) -1)))
10000.times {p RQC.qc {|fix| p "#{fix.happy?} case:"; prc2.call(fix)==fix.happy? }}
