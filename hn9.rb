#@author David Tran (Solution 2)

class Integer
  def digits(base = 10)
    return [self] if self < base
    self.divmod(base).inject { |div, mod| div.digits(base) << mod }
  end

  def happy?(base = 10)
    _happy?([], base)
  end

  protected

  def _happy?(happy_list, base)
    return false if happy_list.include?(self)
    happy_list << self
    return happy_list if self == 1
    self.digits(base).inject(0) { |n, d| n + d*d }._happy?(happy_list, base)
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
10000.times {p RQC.qc {|fix| p "#{fix.happy?} case:"; fix.happy?.class==Array ? prc2.call(fix):prc2.call(fix)==fix.happy? }}

