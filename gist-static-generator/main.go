package main

import (
	"fmt"
	"html/template"
	"net/http"
	netUrl "net/url"
	"os"
	"regexp"
	"strings"
)

func defaultHandler(w http.ResponseWriter, r *http.Request) {
	var fileName string
	if r.URL.Path != "/" {
		http.Error(w, "404 not found", http.StatusNotFound)
	}

	form := template.Must(template.ParseFiles("form.html"))
	switch r.Method {
	case "GET":
		form.Execute(w, nil)
		return
	case "POST":
		if err := r.ParseForm(); err != nil {
			fmt.Fprintf(w, "ParseForm() error: %v", err)
			return
		}

		url, err := netUrl.Parse(r.FormValue("url"))
		if err != nil {
			fmt.Fprintf(w, "error parsing url: %v", r.FormValue("url"))
			return
		}
		r, _ := regexp.Compile("file-(.+)")
		fileNames := r.FindStringSubmatch(url.Fragment)
		if len(fileNames) > 0 {
			fileName = strings.ReplaceAll(fileNames[1], "-", ".")
		}
		form.Execute(w, struct {
			Success bool
			URL     string
		}{
			true,
			fmt.Sprintf("https://gist.githubusercontent.com%v/raw/%v", url.Path, fileName),
		})

	default:
		fmt.Fprintf(w, "only get and post are supported")
	}

}
func main() {
	http.HandleFunc("/", defaultHandler)
	http.ListenAndServe(os.Getenv("PORT"), nil)

}
