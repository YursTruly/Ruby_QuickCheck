require 'rtc_lib'

class Dummy
  rtc_annotated

  typesig('foo : (Numeric) -> Numeric')
  def foo(x)
    x
  end
end

# You have to explicitly annotate values using rtc_annotate for them to be
# typechecked... for example, the following runs fine:
a = Dummy.new
a.foo(3)
a.foo("foo")

# but here we'll get an error on the last call.
b = Dummy.new.rtc_annotate('Dummy')
b.foo(3)
# b.foo("foo")

# rtc_type goes to metaclass, not class
p Dummy.rtc_type
p Dummy.rtc_type.instance_exec { method_types }
p Dummy.rtc_type.get_method :foo

# here rtc_type gets us the right one
p b.rtc_type
p b.rtc_type.instance_exec { method_types }
p (b.rtc_type.get_method :foo).inspect

# Here's one way of getting it for a class directly
dtype = Rtc::Types::NominalType.of(Dummy)
p dtype.instance_exec { method_types }
p dtype.get_method :foo

puts "\n\n"
puts dtype.instance_exec{method_types}.inspect
puts (b.rtc_typeof :foo).arg_types[0].klass
