
all: clean build run

build:
	direnv allow .
	passh -L .10-build-bash-release.log env ./build-bash-release.sh ${BUILD_BASH_VERSION}
	passh -L .20-build-docs.log env ./build-docs.sh
	passh -L .30-compile-libbash-shared-object.log env gcc -o ./RELEASE/lib/libbash.so -Wall -g -shared -fPIC -lm bash.c
	color black green
	echo Build libbash.so
	color reset
	passh -L .40-build-c-go-sh.log /bin/bash --norc --noprofile -c "./build-c-go.sh"
	bash ./build-c-go.sh
	#passh -L .50-build-basic-cgo-binary.log /bin/bash --norc --noprofile -c "./build-c-go.sh && cd ./cmd/basic/. && CGO_ENABLED=1 go build -a -v -o ../../RELEASE/bin/basic main.go"
#	gcc -o hello -L. hello.c -lperson
#	color black cyan
#	echo BUILT hello Binary from C
#	color reset
#	env CGO_ENABLED=1 go build -o main main.go
#	env CGO_ENABLED=1 go build -o cmd/basic/main cmd/basic/main.go
#	color black magenta
#	echo BUILT main Binary from GO
#	color reset

run:
	color black blue
	ls -altr ./RELEASE/lib/libbash.so
	passh -L .40-build-cgo-binary.log bash --norc --noprofile -c "env LD_LIBRARY_PATH=./RELEASE/lib ./RELEASE/bin/main" | grep 'Hello from Go'
	ls -altr ./RELEASE/bin/basic
	color reset
	color black yellow
#	./main
	color reset

clean:
	color black red 
	rm -rf libbash.so 
	echo libbash.so
	color reset
	rm -rf ./.*-*.log

