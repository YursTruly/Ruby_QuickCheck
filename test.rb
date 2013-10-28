require_relative "rbqc"




#pass
rqc = RQC.new(String, :upcase, true) { |x| x.downcase == $upcase_p0.downcase }
p "Hello World!".upcase(rqc)

#pass
rqc1 = RQC.new(String, :reverse, true) {|x| x.reverse == $reverse_p0}
p "Hello World!".reverse(rqc1)


#fail
rqc2 = RQC.new(String, :downcase, true) {|x| x.reverse == $downcase_p0.upcase}
p "hi".downcase(rqc2)