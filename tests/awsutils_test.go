package tests

import (
	"errors"
	"testing"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/route53"
	"github.com/aws/aws-sdk-go/service/route53/route53iface"
	awsutils "github.com/tuannvm/tools/pkg/aws"
)

type mockRoute53 struct {
	route53iface.Route53API
	shouldFail bool
}

func (m *mockRoute53) ListResourceRecordSets(input *route53.ListResourceRecordSetsInput) (*route53.ListResourceRecordSetsOutput, error) {
	if m.shouldFail {
		return nil, errors.New("mock API failure")
	}
	return &route53.ListResourceRecordSetsOutput{}, nil
}

func (m *mockRoute53) ChangeResourceRecordSets(input *route53.ChangeResourceRecordSetsInput) (*route53.ChangeResourceRecordSetsOutput, error) {
	if m.shouldFail {
		return nil, errors.New("mock API failure") 
	}
	return &route53.ChangeResourceRecordSetsOutput{}, nil
}

func TestDeleteRecordsSuccess(t *testing.T) {
	mockConfig := &aws.Config{
		Region: aws.String("us-west-2"),
	}
	
	client := awsutils.NewRoute53Client(mockConfig)
	client.Client = &mockRoute53{}
	
	err := client.DeleteRecords("Z1234567890", []string{"TXT"})
	if err != nil {
		t.Errorf("Unexpected error: %v", err)
	}
}

func TestDeleteRecordsFailure(t *testing.T) {
	mockConfig := &aws.Config{
		Region: aws.String("us-west-2"),
	}
	
	client := awsutils.NewRoute53Client(mockConfig)
	client.Client = &mockRoute53{shouldFail: true}
	
	err := client.DeleteRecords("Z1234567890", []string{"TXT"})
	if err == nil {
		t.Error("Expected error but got none")
	}
}

func TestDeleteRecordsValidation(t *testing.T) {
	mockConfig := &aws.Config{
		Region: aws.String("us-west-2"),
	}
	
	client := awsutils.NewRoute53Client(mockConfig)
	client.Client = &mockRoute53{}
	
	tests := []struct {
		name        string
		hostedZoneID string
		recordTypes []string
	}{
		{"EmptyHostedZone", "", []string{"TXT"}},
		{"EmptyTypes", "Z1234567890", []string{}},
	}
	
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := client.DeleteRecords(tt.hostedZoneID, tt.recordTypes)
			if err == nil {
				t.Error("Expected validation error but got none")
			}
		})
	}
}

func BenchmarkDeleteRecords(b *testing.B) {
	mockConfig := &aws.Config{
		Region: aws.String("us-west-2"),
	}
	
	client := awsutils.NewRoute53Client(mockConfig)
	client.Client = &mockRoute53{}
	
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_ = client.DeleteRecords("Z1234567890", []string{"TXT"})
	}
}

func TestConcurrentDeleteRecords(t *testing.T) {
	mockConfig := &aws.Config{
		Region: aws.String("us-west-2"),
	}
	
	client := awsutils.NewRoute53Client(mockConfig)
	client.Client = &mockRoute53{}
	
	errChan := make(chan error, 10)
	
	for i := 0; i < 10; i++ {
		go func() {
			errChan <- client.DeleteRecords("Z1234567890", []string{"TXT"})
		}()
	}
	
	for i := 0; i < 10; i++ {
		if err := <-errChan; err != nil {
			t.Errorf("Concurrent operation failed: %v", err)
		}
	}
}
