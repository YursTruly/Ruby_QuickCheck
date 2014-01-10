#RQC BENCHMARK IDEAS

#Info to decide generation: borderline values, type bounds, 
#nested instance variable borderline values / type bounds


#DEFINED FUNCTIONAL TESTS

#Tests rqcobj used in comparisons
def b1(x)
	if x>5 then x+1 else x+2 end
end

#Tests rqcobj passed as param
def b2(x)
	if 5*x then true else false end
end

#Tests reassignment of rqcobj
def b3(x)
	x = x+3
	if x<10 then 5**x else x
end

#Tests multiple interactions between rqcobj and other vars
def b4(x)
	y = x+5
	if y>15 then true else false
end

#Tests branching tracking of rqcobj
def b5(x)
	x = x + 3
	if x > 5 then
		if x< 100 then p "hi"
		else p "hi2" end
	else p "hi3" end
end

#Tests multiple rqcobjs
def b6(x,y)
	z = x+y
	if y>z or x>z then true
	elsif z>x*y then false
	else nil end
end

#Tests recursive racobj tests
def b7(x)
	if x>5 then b7(x-1) else 25 end 
end

#Tests rqcobj with different types
def b8(x)
	if x.equals("hello") then x+" world!"
	elsif x==3 then x+5
	else x+2 end
end


#APPLICATION BENCHMARKS

#RSA algorithm? Crypto?
#Machine engine simulator?

