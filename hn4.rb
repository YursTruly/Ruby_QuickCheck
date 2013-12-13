#@author Ken Bloom

require 'enumerator'
require 'jcode'


module Happy
  #1 is a success terminator, from Wolfram's MathWorld
  FAIL_TERMINATORS=[0, 4, 16, 20, 37, 42, 58, 89, 145]

  def internal_happy? number
    return 0 if number==1
    return false if FAIL_TERMINATORS.include? number
    it=Enumerable::Enumerator.new(number.to_s,:each_char)
    newnumber=it.inject(0) { |partial_sum,char| partial_sum+(char.to_i)**2 }
    x=happy?(newnumber)
    return x+1 if x
    return false
  end

  @@memo=Hash.new

  def happy? number
    return @@memo[number] || @@memo[number]=internal_happy?(number)
  end
end

include Happy

#there is no largest happy number because any 10**n is happy for any n.
#since ruby can represent all integers, there's no "largest number I can 
#find" (given enough RAM)

#to find the happiest number between 1 and 1_000_000, we use the 
#following code (which takes advantage of the memoization that I have 
#included)

minhappy=[]
1_000_001.times do |n|
  puts "Progress #{n}" if n%1000==0
  if x=happy?(n)
    if  minhappy[x]==nil or minhappy[x]>n
      minhappy[x]=n
    end
  end
end

puts minhappy.last

#after a long time running, this prints that
#the happiest number is 78999

#by clearing the memoization hash and adding a strategically placed
#puts, I can see this computes happiness for the following
#numbers: [78999, 356, 70, 49, 97, 130, 10, 1]
