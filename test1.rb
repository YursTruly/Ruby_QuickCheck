require_relative "temprqc"

#pass
RQC.qc(Fixnum,Fixnum) {|f1,f2| x=f1.coerce(f2);x[0].class==x[1].class}

#fail
RQC.qc(String) {|str| str.reverse.reverse == "hello"}