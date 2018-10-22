package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"os"
	"strconv"
)

// documentation for csv is at http://golang.org/pkg/encoding/csv/
// TODO: could not find
func main() {
	file, err := os.Open("backend.csv")
	if err != nil {
		// err is printable

		// elements passed are separated by space automatically
		fmt.Println("Error:", err)
		return
	}
	// automatically call Close() at the end of current method
	defer file.Close()
	//
	reader := csv.NewReader(file)
	// options are available at:
	// http://golang.org/src/pkg/encoding/csv/reader.go?s=3213:3671#L94
	reader.Comma = ','
	lineCount := 0

	for {
		// read just one record, but we could ReadAll() as well
		record, err := reader.Read()
		// end-of-file is fitted into err
		if err == io.EOF {
			break
		} else if err != nil {
			fmt.Println("Error:", err)
			return
		}

		// fmt.Println("drone secret add -image", record[3][1:len(record[3])-2], "-repository $DRONE_REPO", "-name", record[1], "-value", record[2])
		fmt.Println("drone secret add -event pull_request -event push -repository $DRONE_REPO", "-name", record[1], "-value", strconv.Quote(record[2]))
		fmt.Println()
		lineCount++
	}

	// for {
	// 	// read just one record, but we could ReadAll() as well
	// 	record, err := reader.Read()
	// 	// end-of-file is fitted into err
	// 	if err == io.EOF {
	// 		break
	// 	} else if err != nil {
	// 		fmt.Println("Error:", err)
	// 		return
	// 	}

	// 	// fmt.Println("drone secret add -image", record[3][1:len(record[3])-2], "-repository $DRONE_REPO", "-name", record[1], "-value", record[2])
	// 	fmt.Println("- source:", strings.ToLower(record[1]))
	// 	fmt.Printf("%v%v %v\n", "  ", " target:", strings.ToLower(record[1]))
	// 	lineCount++
	// }
}
