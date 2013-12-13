#@author Sander Land

class Array
  def sum
    inject(0){|a,b| a+b}
  end
end

class Integer

  def to_digits(base)
    return [self] if self < base
    (self/base).to_digits(base) << self%base
  end

  def happy_function
    to_digits($base).map{|d| d ** 2}.sum
  end

  def happiness
    num = self
    chain = [num]
    until num == 1 || num.cached_happiness == -1
      num.cached_happiness = -1
      chain << num = num.happy_function
    end
    if num == 1
      chain.shift.cached_happiness = chain.size until chain.empty?
    end
    self.cached_happiness
  end

  def happy?
    happiness >= 0
  end

  protected
  def cached_happiness
    return 0 if self==1
    (@happiness||={})[$base]
  end

  def cached_happiness=(val)
    (@happiness||={})[$base] = val
  end
end

def nondec_nums(len,min=0,n=0,&b) # yields all numbers with non-decreasing digit sequences of length <= len
  if len==0
    yield n
  else
    [*min...$base].each{|m| nondec_nums(len-1, m ,n * $base + m,&b) }
  end
end

maxn = maxh = 1
s = Time.now

if ARGV[0] == 'find'
  $base = (ARGV[1] || 10 ).to_i
  MAXLEN = 7
  puts "searching happiest number < #{$base**MAXLEN} in base #{$base}"
  max_n, max_h = 1,0
  nondec_nums(MAXLEN) {|n| # length 7 / up to 9,999,999
  if n.happiness > max_h
    max_n, max_h = n, n.happiness
    puts "n=#{n}\th=#{max_h}\tdigits=#{n.to_digits($base).inspect}"
  end
}
else
  puts "searching for happy bases, press ctrl-c to quit"
  (2..1_000_000).each {|$base|
    len = 3    #  len * (base-1)^2 < b^len - 1  for len >= 3 and any base
    max = $base**len - 1  # upper bound for when \forall n>=max n.happy_function < n   =>  if all numbers of up to and including this length are happy then all numbers are
    max -= $base**(len-1) while max.happy_function < max # further decrease upper bound,  for base 10 this is : 999, 899, 799, etc
    max += $base**(len-1) # previous loop always does 1 step too much
    happy_base = true
    min_unhappy = nil
    nondec_nums(len) {|n|
      if !n.happy?  && n>0
        min_unhappy = n
        happy_base = false
        break
      end
      break if n > max
    }
    puts happy_base ? "base #{$base} is a happy base!" : "base
#{$base} is not a happy base because #{min_unhappy} is unhappy."
  }
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
