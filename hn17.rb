#@author Rick DeNatale

#! /usr/local/bin/ruby

class Integer

        def Integer.reset_happiness_cache
                # Integer#to_s(base) works up to a base of 36
                @@cached_unhappy_ints = Array.new(37) {|i| Hash.new }
                @@cached_happiness_paths = Array.new(37) {|i| {1 => [1]}}

                self.cache_unhappy([0, 4, 16, 20, 37, 42, 58, 89, 145], 10)
        end

        def Integer.show_hc
                puts "unhappies = #{@@cached_unhappy_ints[10].inspect}"
                puts "happies = #{@@cached_happiness_paths[10].inspect}"
        end

        def squared
                self * self
        end

        def sum_squares_of_digits(base=10)
                sum = 0
                to_s(base).each_byte do |b|
                        sum += (b.chr.to_i(base)).squared
                end
                sum
        end

        def path_to_happiness(base=10,seen=[])
                return nil if Integer.known_unhappy?(self, base)
                return Integer.cache_unhappy([self], base) if
seen.include?(self)
                known_path = Integer.known_happiness_path(self, base)
                return known_path.dup if known_path
                rest_of_the_way =
sum_squares_of_digits(base).path_to_happiness(base,seen.dup << self)
                if rest_of_the_way
                        ans = rest_of_the_way.unshift(self)
                        return Integer.cache_happiness_path(ans, base).dup
                else
                        Integer.cache_unhappy([self], base)
                        return nil
                end
        end

        def Integer.known_unhappy?(int, base)
                @@cached_unhappy_ints[base][int]
        end

        def Integer.known_happiness_path(int, base)
                @@cached_happiness_paths[ base][int]
        end

        def known_happy?(base)
                Integer.known_happiness_path(self, base)
        end

        def Integer.cache_unhappy(integers, base)
                integers.each do | n |
                        @@cached_unhappy_ints[base][n] = true
                end
                nil
        end

        def Integer.cache_happiness_path(path, base)
                @@cached_happiness_paths[base][path[0]] = path.dup
                path
        end

        def happy?
                !self.path_to_happiness.nil?
        end

        def happiness
                path = path_to_happiness
                path_to_happiness ? path_to_happiness.length : 0
        end

        reset_happiness_cache
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
