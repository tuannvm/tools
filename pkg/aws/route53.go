package aws

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/route53"
	"github.com/aws/aws-sdk-go/service/route53/route53iface"
)

// Route53Client provides methods for interacting with AWS Route53
type Route53Client struct {
	Client route53iface.Route53API
}

// NewRoute53Client creates a new Route53 client with the given AWS configuration
func NewRoute53Client(cfg *aws.Config) *Route53Client {
	return &Route53Client{
		Client: route53.New(session.Must(session.NewSession(cfg))),
	}
}

// DeleteRecords removes DNS records of specified types from a domain
func (c *Route53Client) DeleteRecords(hostedZoneID string, recordTypes []string) error {
	if hostedZoneID == "" {
		return fmt.Errorf("hosted zone ID cannot be empty")
	}
	if len(recordTypes) == 0 {
		return fmt.Errorf("at least one record type must be specified")
	}

	// List current records
	listParams := &route53.ListResourceRecordSetsInput{
		HostedZoneId: aws.String(hostedZoneID),
	}
	records, err := c.Client.ListResourceRecordSets(listParams)
	if err != nil {
		return err
	}

	// Filter by type and prepare changes
	var changes []*route53.Change
	for _, record := range records.ResourceRecordSets {
		for _, recordType := range recordTypes {
			if *record.Type == recordType {
				changes = append(changes, &route53.Change{
					Action:            aws.String("DELETE"),
					ResourceRecordSet: record,
				})
			}
		}
	}

	// Submit changes if any
	if len(changes) > 0 {
		changeParams := &route53.ChangeResourceRecordSetsInput{
			HostedZoneId: aws.String(hostedZoneID),
			ChangeBatch: &route53.ChangeBatch{
				Changes: changes,
			},
		}
		_, err = c.Client.ChangeResourceRecordSets(changeParams)
		if err != nil {
			return err
		}
	}

	return nil
}
