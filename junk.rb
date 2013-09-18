require 'rtc_lib'

class Dummy
  rtc_annotated

  typesig("foo : (Numeric) -> Numeric")
  def foo(x)
    x
  end
end

a = Dummy.new
a.foo(3)
a.foo("foo")

b = Dummy.new.rtc_annotate("Dummy")
b.foo(3)
b.foo("foo")
