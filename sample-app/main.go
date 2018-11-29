package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "hello %s", os.Getenv("Foo"))
	})
	err := http.ListenAndServe(":8888", nil)
	fmt.Println(err)
}
