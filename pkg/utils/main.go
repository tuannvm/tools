package utils

import (
	"regexp"
)

var mailRegexp = regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)

// IsEmailValid check if provided email is valid
func IsEmailValid(email string) bool {
	return mailRegexp.MatchString(email)
}
