
#!/usr/bin/env ruby
#
# =Description
#
# This program determines the happiness of a number, or the happiest number and 
# highest happy number in a range of numbers.
#
# A number's happiness is determined as follows: Sum the squares of the number's
# individual digits. Repeat this process with the result, until a value of 1 is
# reached, or until a value is repeated, thus indicating a loop that will never
# reach 1. A number for which 1 is reached is "happy". The number of other 
# numbers generated besides 1 and the original number is its happiness value.
#
# =Usage
# 
# happy.rb num1[-num2][:base]
#
# happy.rb takes a single argument. If the argument is a single number, that
# number's happiness value is displayed, or the number is said to be unhappy.
# If the argument is a range of numbers, such as "1-400", the happiness value of
# the happiest number (lowest number breaking ties) in that range is returned.
# If the argument ends with a colon and a number, such as "50:8" or "1-100:2",
# the number after the colon specifies the base of the first number(s). An
# unspecified base implies base ten.

require 'rdoc/usage'

#==============================================================================
# ----- Global variables -----
#==============================================================================

$hap_map = {} # Hash for memoization of happiness values

#==============================================================================
# ----- Instance methods -----
#==============================================================================
class String
  # Indicates whether the string is a valid number of the specified base.
  def is_num_of_base?(base)
    # sub() call removes leading zeros for comparison
    self.sub(/\A0+/, '').downcase == self.to_i(base).to_s(base).downcase 
  end
end

class Integer
  # Pretty-print string including base, if base is not 10
  def pretty(base)
    self.to_s(base) + ((base == 10) ? "" : " (base #{base})")
  end
end

#==============================================================================
# ----- Global methods -----
#==============================================================================

# This method returns the happiness value of the given number. A value of -1
# indicates that the number is unhappy.
def get_happy(num, base=10)
  $hap_map[num] = 0 if num == 1 # Handles trivial case
  return $hap_map[num] if $hap_map[num]

  ret = 0
  done = false
  inters = []
  temp = num
  
  until done
    digits = temp.to_s(base).split(//).map{|c| c.to_i(base)}
    temp = digits.inject(0) {|sum, d| sum + d**2}
    ret += 1

    if (temp != 1) && $hap_map[temp]
      # Optimization; use knowledge stored in $hap_map
      if $hap_map[temp] == -1
        ret = -1
        done = true
      else
        ret += $hap_map[temp]
        done = true
      end
    else
      if temp == 1
        ret -= 1 # Don't count 1 as an intermediate happy number
        done = true
      elsif inters.include?(temp)
        ret = -1
        done = true
      else
        inters << temp
      end
    end
  end

  $hap_map[num] = ret

  # Optimization
  if ret == -1
    # If num is not happy, none of the intermediates are happy either
    inters.each {|n| $hap_map[n] = -1}
  else
    # If num is happy, each intermediate has a happiness value determined by 
    # its position in the array
    inters.each_index {|idx| $hap_map[inters[idx]] = (ret - 1) - idx}
  end

  return ret
end

# nums is a range of integers. This method returns two values: the happiest 
# number, and the highest happy number, in the range. Two nil values will be 
# returned if there are no happy numbers in the range.
def get_superlatives(nums, base)
  happiest_num = nil
  happiest_ness = nil
  highest = nil

  nums.each do |n|
    happy = get_happy(n, base)
    next if happy == -1
    highest = n

    if (!happiest_ness) || (happy > happiest_ness)
      happiest_num = n
      happiest_ness = happy
    end
  end

  return happiest_num, highest
end

#==============================================================================
# ----- Script start -----
#==============================================================================

if ARGV.size != 1
  RDoc.usage('Usage', 'Description')
end

# Parse arg
ARGV[0] =~ /\A([\d\w]+)(?:\-([\d\w]+))?(?::(\d+))?\Z/
num1, num2, base = $1, $2, $3

# Ensure legal arg
RDoc.usage('Usage', 'Description') unless num1

# Fill in defaults
base = 10 unless base
num2 = num1 unless num2

# Convert numbers from strings to numeric values
base = base.to_i

[num1, num2].each do |s|
  unless s.is_num_of_base?(base)
    puts "Error: #{s} is not a valid base #{base} number"
    exit
  end
end

num1 = num1.to_i(base)
num2 = num2.to_i(base)

# Calculate and print results
if num1 == num2
  happiness = get_happy(num1, base)
  
  print num1.pretty(base)
  
  if happiness == -1
    print " is not happy.\n"
  else
    print " has a happiness of #{happiness}\n"
  end
else
  if num1 > num2
    num1, num2 = num2, num1
  end

  happiest, highest = get_superlatives((num1..num2), base)

  if !highest
    puts "None of those numbers are happy."
  else
    puts "The happiest number is " + happiest.pretty(base) +
      ", with a happiness of #{get_happy(happiest, base)}"

    puts "The highest happy number is " + highest.pretty(base) + 
      ", with a happiness of #{get_happy(highest, base)}"
  end
end
 
#Karl von Laudermann - karlvonl(a)rcn.com - http://www.geocities.com/~karlvonl