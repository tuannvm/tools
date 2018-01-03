package main

import (
	"fmt"
	"net"
	"net/http"
	"os"

	"github.com/gorilla/handlers"
)

func main() {

	r := http.NewServeMux()

	r.Handle("/", handlers.LoggingHandler(os.Stdout, http.HandlerFunc(ipHandler)))
	http.ListenAndServe("127.0.0.1:2311", handlers.CompressHandler(r))
}

func ipHandler(w http.ResponseWriter, r *http.Request) {
	headers := []string{"X-Forwarded-For", "Remote-Addr", "X-Real-Ip"} // 3 headers to trust to get IP from
	ip, _ := ipFromRequest(headers, r)
	fmt.Fprintf(w, "%v", ip)
}

func ipFromRequest(headers []string, r *http.Request) (net.IP, error) {
	var ips []string
	for _, header := range headers { // loop through the headers slice
		ip := r.Header.Get(header)
		if ip != "" {
			ips = append(ips, ip)
		}
	}
	fmt.Println("ips:", ips)
	if len(ips) > 1 { // no IP available in headers, use RemoteAddr instead
		for index := len(ips); index > 0; index-- {
			if checkPublicIP(ips[index-1]) { // Immediately return first public IP (from right to left) if found, see
				return net.ParseIP("2.2.2.2"), nil
			}
		}
	} else if len(ips) == 1 { // only one found
		return net.ParseIP("3.3.3.3"), nil
	}

	_, _, err := net.SplitHostPort(r.RemoteAddr)
	return net.ParseIP("1.1.1.1"), err
}

func checkPublicIP(str string) bool {
	ip := net.ParseIP(str)
	if ip.IsGlobalUnicast() || ip.IsInterfaceLocalMulticast() || ip.IsLinkLocalMulticast() || ip.IsLinkLocalUnicast() || ip.IsLoopback() || ip.IsMulticast() || ip.IsUnspecified() { // check if IP is public, looks tidious :|
		fmt.Println("failed ip: ", str)
		return false

	}
	return true
}
