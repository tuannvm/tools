package utils

import (
	"testing"
)

func TestIsValidEmail(t *testing.T) {
	const checkMark = "\u2713"
	const ballotX = "\u2717"

	emails := []struct {
		email string
		valid bool
	}{
		{
			"test@sample.com",
			true,
		},
		{
			"test",
			false,
		},
	}

	t.Log("Given the need to test email address.")
	{
		for _, e := range emails {
			t.Logf("\tChecking email \"%s\" 's validity", e.email)
			{
				valid := IsEmailValid(e.email)
				if valid == e.valid {
					t.Log("Email should be valid as expected", checkMark)
				} else {
					t.Errorf("\t\t email \"%s\" 's validity is \"%v\" %v", e.email, e.valid, ballotX)
				}
			}
		}
	}
}
