require_relative "temprqc"
require_relative "CustomTest"

#pass
RQC.qc(Fixnum,Fixnum) {|f1,f2| x=f1.coerce(f2);x[0].class==x[1].class}

#pass
RQC.qc([TestModule::Klass,String,Fixnum],Fixnum,String) {|kls,fix,str| kls.mthd2(fix,str)}

#fail
RQC.qc(String) {|str| str.reverse.reverse == "hello"}