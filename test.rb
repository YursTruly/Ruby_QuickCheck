require_relative "rbqc"

#pass
rqc = RQC.new(String, :upcase) { |x| x.downcase == $upcase_p0.downcase }
p "Hello World!".upcase(rqc)
puts "\n"
# TO DO:
# Log cases
#rqc.spec_gen([Fixnum])

#pass
rqc1 = RQC.new(String, :reverse) {|x| x.reverse == $reverse_p0}
p "Hello World!".reverse(rqc1)
puts "\n"

#fail
rqc2 = RQC.new(String, :downcase) {|x| x.reverse == $downcase_p0.upcase}
p "hi".downcase(rqc2)
puts "\n"
#pass
#rqc4 = RQC.new(Float, :floor) {|x| x <= $floor_p0}
#p 3.25.floor(rqc4)

#pass
rqc3 = RQC.new(Numeric, :coerce) {|x| x[0].class==x[1].class}
rqc3.spec_gen([Numeric])
p 5.coerce(rqc3,6.2)
puts "\n"