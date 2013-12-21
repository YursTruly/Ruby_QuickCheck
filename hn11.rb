#@author Eric Torreborre

 class Fixnum
   def happy_number?
     EmotiveNumber.new(self).happy?
   end
 end

 def find_happy_numbers(n)
   (1..n).select{|seed| seed.happy_number?}
 end

 def find_happiest_number(n)
   happiest, max_size = 1, 1
   (1..n).each do |seed|
     emotive = EmotiveNumber.new(seed)
     happiest, max_size = seed, emotive.size if (emotive.happy? &&  
 emotive.size > max_size)
   end
   return happiest
 end



   class EmotiveNumber
   CYCLIC_NUMBERS = [4, 16, 37, 58, 89, 145, 42, 20]
   attr_reader :suite

   def initialize(seed)
     @suite = []
     compute_suite(seed)
   end

   def happy?
     suite.last == 1
   end

   def size
     suite.size
   end

 private

   def compute_suite(seed)
     next_element = seed
     while (!happy? && !CYCLIC_NUMBERS.include?(next_element))
       @suite << next_element
       next_element = square_sum(@suite.last)
     end
     @suite += CYCLIC_NUMBERS if !happy?
   end

   def square_sum(num)
     num.to_s.split(//).inject(0){|result, i| result += i.to_i*i.to_i}
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
100.times {p RQC.qc {|fix| p "#{fix.happy_number?} case:"; prc2.call(fix)==fix.happy_number? }}
