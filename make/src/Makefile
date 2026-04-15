CXX=g++

all: a.out

a.out: main.o sub.o
	$(CXX) main.o sub.o

%.o: %.cpp
	$(CXX) -c $<

clean:
	rm -f a.out *.o

-include makefile.dep
