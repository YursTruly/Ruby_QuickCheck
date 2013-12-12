require_relative "rqc"
require_relative "CustomTest"
srand

#pass
RQC.qc(Fixnum,Fixnum) {|f1,f2| x=f1.coerce(f2);x[0].class==x[1].class}

#pass
RQC.qc([TestModule::Klass,String,Fixnum],Fixnum,String) {|kls,fix,str| kls.mthd2(fix,str)}

#RubyQuiz 22
prc = Proc.new {
x = ["I","IV","V","IX","X","XL","L","XC","C","CD","D","CM","M"].reverse
y = [1,4,5,9,10,40,50,90,100,400,500,900,1000].reverse
nums = [3,1,3,1,3,1,1,1,3,1,1,1,3]
numCt = [0,0,0,0,0,0,0,0,0,0,0,0,0]
rNum = ""
aNum = 0
(0..12).each {|i| if numCt[i-1]==0 then numCt[i] = rand(0..nums[i]) end}
numCt.reverse
(0..12).each {|i| numCt[i].times {rNum += x[i]; aNum += y[i]} }
}

#RubyQuiz 93
prc2 = Proc.new {
|x|
tempArr = []
until x<=0 tempArr<<(x%10)**2; x=x/10 end
sum=0
for i in 0...(tempArr.size) sum +=tempArr[i] end
if sum==1 then true else prc2.call(sum) end
}

def run_happy_number

end

RQC.qc(Fixnum)
$prm_generators[0].instance_variable_get(:@domain)==0..((2**(0.size * 8 - 2) -1))
RQC.qc() {|fix| if run_happy_number(fix) then prc.call(fix) else p "Cannot determine false case"; false end}

#fail
#RQC.qc(String) {|str| str.reverse.reverse == "hello"}