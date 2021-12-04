package main

/*
#cgo CFLAGS: -g -Wall -fPIC
#cgo LDFLAGS: -L./../../RELEASE/lib
#include "./../../bash.c"
*/
import "C"
import (
	"fmt"
	"os"

	bash "local.dev/cgo-bash"
)

func ExampleRegister() {
	bash.Register("hello", hello)
	status := bash.Main([]string{os.Args[0], "-c", "hello world"}, os.Environ())
	fmt.Println("exit status", status)
	// Output:
	// Hello from Go! args=[world]
	// exit status 42
}

func hello(args ...string) (status int) {
	fmt.Printf("Hello from Go! args=%v\n", args)
	return 42
}

func main() {
	fmt.Println("CGO MAIN")
	ExampleRegister()
}
