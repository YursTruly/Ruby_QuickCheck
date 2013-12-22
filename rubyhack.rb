#ruby hack test

#Ruby MRI/vm_eval.c
#static inline VALUE
#rb_call(VALUE klass, VALUE recv, ID mid, int argc, const VALUE *argv, VALUE obj, int call_status)
#	method body
#end

def hi(x) #x can be Numeric or String
	p "hi called"
	x = x*5
end


obj = BasicObject.new
class << obj
	def method_missing(name, *args, &blk)
		return name
	end
end


#p obj+1

def blank(x)
	eval("
	obj = BasicObject.new; 
	class << obj; 
		def method_missing(name, *args, &blk);
			
			#{x.object_id}.send(name,*args,&blk)
		end;
	end;
	")
end

class RQC_blank < BasicObject
	
	def initialize(x)
		@obj = x
	end
	
	def p (str)
		"".instance_eval("p \"#{name}\"")
	end
	
	def method_missing(name, *args, &blk)
		#p name
		@obj.send(name, *args, &blk)
	end
	
end

y = RQC_blank.new(5)
p y.methods
hi(5)