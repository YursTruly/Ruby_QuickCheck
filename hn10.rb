#@author Vance Heron

#! /usr/bin/env ruby

def sum_dig_sq(ival)
  sum = 0
  while ival > 0 do
    ival,dig = ival.divmod(10)
    sum += (dig * dig)
  end
  return sum
end

def happy?(ival)
# sad #s from http://mathworld.wolfram.com/HappyNumber.html
sad = [0, 4, 16, 20, 37, 42, 58, 89, 145]
rank = 0
while true do
  return -1 if sad.include?(ival) # check sad 1st - ~87% are sad
  ival = sum_dig_sq(ival)
  return rank if ival == 1
  rank += 1
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
10000.times {p RQC.qc {|fix| p "#{happy?(fix)} case:"; prc2.call(fix)==!(happy?(fix)==-1) }}
