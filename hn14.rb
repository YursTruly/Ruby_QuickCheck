#@author Bob Showalter

class Integer

    # cache of happy true/false by number
    @@happy = Hash.new

    # sum of squares of digits
    def sosqod
      sum = 0
      self.to_s.each_byte { |d| d -= ?0; sum += d * d }
      sum
    end

    # am I a happy number?
    def happy?
      return true if self == 1
      return @@happy[self] if @@happy.include?(self)
      @@happy[self] = false
      @@happy[self] = self.sosqod.happy?
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
100.times {p RQC.qc {|fix| p "#{fix.happy?} case:"; prc2.call(fix)==fix.happy?}}
