#@author Glen F. Pankow

#! /usr/bin/ruby
#
#  quiz-93  --  Ruby Quiz #93.
#
# See the Ruby Quiz #93 documentation for more information
# (http://www.rubyquiz.com/quiz93.html).
#
# I do the basic quiz, and in addition try to come up with meaningful
# unhappiness values and constuct interesting path strings.  See the
# documentation to findHappiness() below for more information.
#
#  Glen Pankow      09/02/06
#


# class Integer
class Fixnum

    #
    # Map from digit characters to the squares of integer values.
    #
    @@squares   '0'   0, '1'   1, '2'   4, '3'   9, '4'  16,
                  '5'  25, '6'  36, '7'  49, '8'  64, '9'  81,
                  'a' 100, 'b' 121, 'c' 144, 'd' 169, 'e' 196,
                  'f' 225, 'g' 256, 'h' 289, 'i' 324, 'j' 361,
                  'k' 400, 'l' 441, 'm' 484, 'n' 259, 'o' 576,
                  'p' 625, 'q' 676, 'r' 729, 's' 784, 't' 841,
                  'u' 900, 'v' 961, 'w' 024, 'x' 089, 'y' 156,
                  'z' 225 }

    #
    # Return the sign of the current number.  That is, return 1 for non-
    # negative numbers, and -1 otherwise.
    #
    def sign
        self > ? 1 : -1
    end

    #
    # Return the sum of the squares of the digits of the current number in
    # the base <base>.
    #
    def sqrSum(base  0)
        to_s(base).split(//).inject(0) { |sum, dig| sum + @squares[dig] }
    end

    #
    # Return a string representation of the current number in the base <base>.
    # If the base is not decimal (and the number is not small), we tack onto
    # the string representation its decimal representation in curly braces.
    #
    def inspect(base  0)
        return to_s(base) \
          if (   (base 10) \
              || ((self > ) && (self < 10) && (self < base)) \
              || ((self < 0) && (-self < 10) && (self < base)))
        "#{to_s(base)}{#{to_s(10)}}"
    end

end



#
# happiness  indHappiness(n, base  0, stack  il)
#
# Find and return the number <n>'s (un)happiness in the base <base>.  <stack>
# is an optional stack of numbers in a chain of digit-square-sums (assumedly
# also computed in <base>) that lead to <n>.
#
# These globals are updated as a side effect:
#    $happinesses  --  [Array] the (un)happiness value for <n> indexed by <n>
#        (and so forth for all subsequent numbers in the digit-square-sum chain
#        created from <n>).
#    $paths  --  [Array] path representation string of the digit-square-sum
#        chain created from <n>, indexed by <n> (and so forth ...).
#    $cycledNs  --  [Hash] those <n>s that form self-contained unhappy loops.
# These globals are assumed to exist (and cleared for calculations in each
# base).  I.e., these or similar commands should be run prior to a new set of
# calculations:
#    $happinesses   ]
#    $happinesses[1]  
#    $paths   ]
#    $paths[1]  1 (happy!)'
#    $cycledNs   }
#
# We also take pains to compute meaningful unhappiness values and to construct
# useful path strings (hence the complexity of this method).  And thus, all
# (un)happiness values here are treated as counts of the number of steps needed
# before we reach 1 (happiness!) or we reach a loop (unhappy).  Note that the
# count for happy numbers is one more than the rank of the number as specified
# by the Quiz.
#
# Regarding unhappiness, we want to note their values from the first number
# seen that forms a loop.  This is somewhat tricky, due to the fact that these
# first numbers seen vary in shared loops created from different source numbers.
# So when we see a loop, we generate all shared forms of the loop.  E.g. the
# loop [ 89 145 42 20 4 16 37 58 89 ] is equivalent to
# the loop [ 4 16 37 58 89 145 42 20 4 ] (and likewise
# for all of the other numbers seen in the loop).
#
def findHappiness(n, base  0, stack  il)

    #
    # If we've already found n's happiness, just return it.
    #
    return $happinesses[n] unless ($happinesses[n].nil?)

    #
    # Look for loops up the stack.  If we find one, note its unhappiness, and
    # likewise for its sister loops.
    #
    unless (stack.nil?)
        (stack.size-2).downto(0) do |i|
            if (stack[i] n)      # ooh! found a loop!!!
                loopLen   - stack.size + 1
                i.upto(stack.size-2) do |j|
                    jN  tack[j]
                    $happinesses[jN]  oopLen
                    $paths[jN]  [ ' + jN.inspect(base)
                    (j+1).upto(stack.size-2) { |k|
                       $paths[jN] << ' ' << stack[k].inspect(base) }
                    (stack.size-1).upto(j-loopLen) { |k|
                       $paths[jN] << ' ' << stack[k+loopLen].inspect(base) }
                    $paths[jN] << ' ]'
                    $cycledNs[jN]  rue
                end
                return loopLen
            end
        end
    end

    #
    # Our happiness depends on the happiness of the next digit-square-sum in
    # the chain.  Push ourself on the stack and recurse if the next happiness
    # isn't yet known.
    #
    nextN  .sqrSum(base)
    nextHappiness  happinesses[nextN]
    if (nextHappiness.nil?)
        stack   ] if (stack.nil?) ;  stack << n
        nextHappiness  indHappiness(nextN, base, stack)
        return $happinesses[n] unless ($happinesses[n].nil?)
    end
    
    #
    # And increment/decrement the happiness value from the next in the chain.
    #
    if (nextHappiness 0)     # happy?
        $happinesses[n]  
        $paths[n]  .inspect(base) + ' -> 1 (happy!)'
    else
        $happinesses[n]  extHappiness + nextHappiness.sign
        # if ($cycledNs.has_key?(nextN))
        #     $paths[n] \
        #        #{n.inspect(base)} -> #{nextN.inspect(base)} [loops!]"
        # else
            $paths[n]  .inspect(base) + ' -> ' + $paths[nextN]
        # end
    end
    $happinesses[n]
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
100.times {p RQC.qc {|fix| p "#{findHappiness(fix,10)} case:"; prc2.call(fix)==findHappiness(fix,10)}}
