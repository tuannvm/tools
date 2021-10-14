package main

import (
	"log"
	"net/smtp"
)

func main() {
	endpoint := ""
	port := ""
	username := ""
	password := ""

	sender := ""
	recipient := ""
	// Set up authentication information.
	auth := smtp.PlainAuth("", username, password, endpoint)

	to := []string{recipient}
        msg := []byte("From: " + sender + "\r\n" +
                "To: " + recipient + "\r\n" +
		"Subject: discount Gophers!\r\n" +
		"\r\n" +
		"This is the email body.\r\n")
	err := smtp.SendMail(endpoint+":"+port, auth, sender, to, msg)
	if err != nil {
		log.Fatal(err)
	}
}
