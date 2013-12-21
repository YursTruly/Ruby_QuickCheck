
#!/usr/bin/ruby
# Ruby happy number quiz solution.  September 2006
# Hans Fugal

require 'set'

class Happy
   def initialize
     @happy_numbers = { 1 => 0 }
     @unhappy_numbers = Set.new
   end

   def happy(x)
     return true if @happy_numbers.has_key?(x)
     return false if @unhappy_numbers.include?(x)

     path = [x]
     loop do
       sum = 0
       while x > 0
         x, r = x.divmod(10)
         sum += r**2
       end

       if @unhappy_numbers.include?(sum)
         return false
       elsif @happy_numbers.has_key?(sum)
         r = @happy_numbers[sum]
         path.each_with_index do |x,i|
           @happy_numbers[x] = r + path.size - i
         end
         return true
       end

       path.push sum

       if [0, 1, 4, 16, 20, 37, 42, 58, 89, 145].include?(sum)
         if sum == 1
           s = path.size
           path.each_with_index do |x,i|
             @happy_numbers[x] = s - i - 1
           end
           return true
         else
           path.each do |x|
             @unhappy_numbers.add x
           end
           return false
         end
       end

       x = sum
     end
   end

   def rank(x)
     raise ArgumentError, "#{x} is unhappy." unless happy(x)
     return @happy_numbers[x]
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
hp = Happy.new
10000.times {p RQC.qc {|fix| p "#{hp.happy(fix)} case:"; prc2.call(fix)==hp.happy(fix) }}
