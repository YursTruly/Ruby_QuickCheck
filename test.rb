require_relative "rbqc"

rqc = RQC.new(String, :upcase) { |x| x.downcase = $upcase_prm1 }
#rqc.checks = { |x| x.downcase = $upcase_prm1 } #rewriting checks
rqc.spec_gen([String])
#rqc.route_sym(String, :downcast) #just prepping another method to check, for no reason

"Hello World!".upcase(rqc)