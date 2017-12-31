package main

import (
	"fmt"
	"net"
	"net/http"
)

func main() {
	http.HandleFunc("/ip", ipHandler)
	http.ListenAndServe(":2311", nil)
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
	if len(ips) == 0 { // no IP available in headers, use RemoteAddr instead
		host, _, err := net.SplitHostPort(r.RemoteAddr)
		return net.ParseIP(host), err
	} else if len(ips) == 1 { // only one found
		return net.ParseIP(ips[0]), nil
	} else {
		for index := len(ips); index > 0; index-- {
			if checkPublicIP(ips[index]) { // Immediately return first public IP (from right to left) if found, see
				return net.ParseIP(ips[index]), nil
			}
		}
	}
	return nil, fmt.Errorf("could not parse IP")
}

func checkPublicIP(str string) bool {
	ip := net.ParseIP(str)
	if ip.IsGlobalUnicast() || ip.IsInterfaceLocalMulticast() || ip.IsLinkLocalMulticast() || ip.IsLinkLocalUnicast() || ip.IsLoopback() || ip.IsMulticast() || ip.IsUnspecified() { // check if IP is public, looks tidious :|
		return false
	}
	return true
}
