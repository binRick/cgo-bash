
all: clean build run

build:
	passh -L .10-build-bash-release.log env ./build-bash-release.sh 3.2.57
	passh -L .20-build-docs.log env ./build-docs.sh
	passh -L .30-compile-libbash-shared-object.log env gcc -o libbash.so -Wall -g -shared -fPIC -lm bash.c
	color black green
	echo Build libbash.so
	color reset
	passh -L .40-build-cgo-binary.log bash --norc --noprofile -c "cd ./bt/. && ./build.sh"
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
	ls -altr libbash.so
	passh -L .40-build-cgo-binary.log bash --norc --noprofile -c "cd ./bt/. && env LD_LIBRARY_PATH=../. ./main" | grep 'Hello from Go'
	ls -altr bt/main
	color reset
	color black yellow
#	./main
	color reset

clean:
	color black red 
	rm -rf libbash.so 
	echo libbash.so
	color reset
