require 'Ruber_checker'
#require 'ruby_check'
#require 'test'

class Tester

x = Ruber_checker.new
rndm = RandomClass.new(0,"hi")
puts x.Custom_gen(rndm.class.name, 0, "hi")

end