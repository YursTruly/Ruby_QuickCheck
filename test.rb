require_relative "rbqc"

rqc = RQC.new(String, :upcase, true) { |x| x.downcase == $upcase_p0.downcase }
rqc.spec_gen([])

p "Hello World!".upcase(rqc)