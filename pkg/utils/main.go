package utils

import (
	"encoding/csv"
	"io"
	"math/rand"
	"reflect"
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

// SliceExists check if element exists
func SliceExists(slice interface{}, item interface{}) bool {
	s := reflect.ValueOf(slice)

	if s.Kind() != reflect.Slice {
		panic("SliceExists() given a non-slice type")
	}

	for i := 0; i < s.Len(); i++ {
		if s.Index(i).Interface() == item {
			return true
		}
	}

	return false
}

// RandomString generate fixed length random string
func RandomString(len int) string {
	bytes := make([]byte, len)
	for i := 0; i < len; i++ {
		bytes[i] = byte(65 + rand.Intn(25)) //A=65 and Z = 65+25
	}
	return string(bytes)
}
