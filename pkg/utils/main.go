package utils

import (
	"encoding/csv"
	"io"
	"regexp"
)

var mailRegexp = regexp.MustCompile(`^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,4}$`)

// IsEmailValid check if provided email is valid
func IsEmailValid(email string) bool {
	return mailRegexp.MatchString(email)
}

// SaveToCsv take string map and write to csv file
func SaveToCsv(w io.Writer, data [][]string) error {
	writer := csv.NewWriter(w)

	if err := writer.WriteAll(data); err != nil {
		return err
	}
	return nil
}
