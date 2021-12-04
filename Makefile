
all: clean build run

build:
	bash build.sh 3.2.57
	bash doc.sh
	gcc -o libbash.so -Wall -g -shared -fPIC -lm bash.c
	color black green
	echo BUILT libbash.so Shared Object
	color reset
#	gcc -o hello -L. hello.c -lperson
#	color black cyan
#	echo BUILT hello Binary from C
#	color reset
#	env CGO_ENABLED=1 go build -o main main.go
#	env CGO_ENABLED=1 go build -o bt/main bt/main.go
#	color black magenta
#	echo BUILT main Binary from GO
#	color reset

run:
	color black blue
#	LD_LIBRARY_PATH=. ./hello
	color reset
	color black yellow
#	./main
	color reset

clean:
	color black red 
	rm -rf libbash.so 
	echo libbash.so
	color reset
