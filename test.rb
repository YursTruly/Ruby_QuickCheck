require_relative "rbqc"

#pass
rqc = RQC.new(String, :upcase, true) { |x| x.downcase == $upcase_p0.downcase }
p "Hello World!".upcase(rqc)
#TO DO:
# Fix NEW (Floats,etc.)

#pass
rqc1 = RQC.new(String, :reverse, true) {|x| x.reverse == $reverse_p0}
p "Hello World!".reverse(rqc1)

#fail
rqc2 = RQC.new(String, :downcase, true) {|x| x.reverse == $downcase_p0.upcase}
p "hi".downcase(rqc2)

#pass
rqc4 = RQC.new(Float, :floor, true) {|x| x <= $floor_p0}
p 3.25.floor(rqc4)

#pass
rqc3 = RQC.new(Numeric, :coerce, true) {|x| x[0].class==x[1].class}
rqc3.spec_gen([Numeric])
p 5.coerce(rqc3,6.2)