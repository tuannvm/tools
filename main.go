package main

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/tuannvm/tools/pkg/awsutils"
)

func main() {
	client := awsutils.New(&aws.Config{})
	client.DeleteRoute53Records("sandbox.honestbee.com", "internal", []string{"TXT", "A"})
}
