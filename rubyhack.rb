#ruby hack test

#Ruby MRI/vm_eval.c
#static inline VALUE
#rb_call(VALUE klass, VALUE recv, ID mid, int argc, const VALUE *argv, VALUE obj, int call_status)
#	method body
#end

def hi(x) #x can be Numeric or String
	x = x*5
end


obj = "hello"
class << obj
	for i in self.methods do
		p i
		begin 
			undef i
		rescue
			p ""
		end
		#remove_method i
	end
end
p obj.methods