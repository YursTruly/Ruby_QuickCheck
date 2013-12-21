#@author: Tim Hoolihan

class Happy
    @@cache = []
    attr_accessor :num,:happy,:friends,:checked
    def initialize(num,friends=[])
        @num=num.to_i
        (return @@cache[@num]) if @@cache[@num]
        @friends=friends
        @happy=false
        check
        self
    end

    def check
        return @happy if @checked
        dig = @num.to_s.split("")
        dig = dig.map{|n| n.to_i }
        res = dig.inject(0){|sum,d| sum + d * d }
        if(res==1)
            @friends = []
            return save(true)
        else
            if(@friends.include?(res))
                return save(false)
            else
                h = Happy.new(res,@friends + [@num])
                if(@happy=h.happy)
                    @friends = h.friends + [h.num]
                    return save(true)
                else
                    return save(false)
                end
            end
        end
    end

    def save(happy)
        @happy=happy
        @checked=true
        @@cache[@num]=self
        self
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
100.times {p RQC.qc {|fix| h=Happy.new(fix); p "#{h.happy} case:"; prc2.call(fix)==h.happy}}
