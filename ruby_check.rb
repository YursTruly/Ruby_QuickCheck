#require 'rtc'


#QuickCheck for Ruby
class ruber_checker

#typesig ("test_gen: (.?) -> (.?)") 
# @params types: Array of types, rules: Bloc of constraints, times: number of tests
# @return valid test set
def test_gen (types, rules)
	case types.get_type#[0].get_type
	when int
		return rand(255)
end

# @params 
# @return
def parse_method()






#Dummy test case for quicker testing purposes; Also serves as default for improper calls
def default_test_case (x , y)
	x + y
end

end

#Data structure for test results
class test_set

end