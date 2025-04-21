// Package aws provides utilities for interacting with AWS services
// including Route53 record management.
//
// Example:
//  config := &aws.Config{Region: aws.String("us-west-2")}
//  client := NewRoute53Client(config)
//  err := client.DeleteRecords("example.com", []string{"TXT"})
package aws
