package awsutils

import (
	"errors"
	"fmt"
	"regexp"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/iam"
	"github.com/aws/aws-sdk-go/service/route53"
	"github.com/tuannvm/tools/pkg/utils"
)

// listUsers list all users
func (client *Client) listUsers() {
	output, err := client.IAM.ListUsersWithContext(client.Context, &iam.ListUsersInput{})
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(output)
}

// GetHostedZoneID will retrieve zone id of specific domain
func (client *Client) GetHostedZoneID(domain string) (*string, error) {
	r, err := regexp.Compile("/hostedzone/(.+)")
	if err != nil {
		return nil, err
	}

	output, err := client.Route53.ListHostedZonesByNameWithContext(client.Context, &route53.ListHostedZonesByNameInput{
		DNSName: &domain,
	})
	if err != nil {
		return nil, err
	}

	for _, hostZone := range output.HostedZones {
		if domain+"." == aws.StringValue(hostZone.Name) {
			return aws.String(r.FindStringSubmatch(aws.StringValue(hostZone.Id))[1]), nil
		}
	}
	return nil, errors.New("Record not found")
}

// ListRoute53Records list all matched record in specific zone
func (client *Client) ListRoute53Records(zoneID *string, pattern string) (recordsList []*route53.ResourceRecordSet, err error) {

	err = client.Route53.ListResourceRecordSetsPagesWithContext(client.Context, &route53.ListResourceRecordSetsInput{
		HostedZoneId: zoneID,
	}, func(p *route53.ListResourceRecordSetsOutput, last bool) (shouldContinue bool) {
		for _, record := range p.ResourceRecordSets {
			if strings.Contains(aws.StringValue(record.Name), pattern) {
				recordsList = append(recordsList, record)
			}
		}
		return true
	})
	if err != nil {
		return nil, err
	}
	return
}

// DeleteRoute53Records route53 records that match the pattern
func (client *Client) DeleteRoute53Records(domain string, pattern string, recordTypes []string) error {

	zoneID, err := client.GetHostedZoneID(domain)
	if err != nil {
		return err
	}
	recordsList, err := client.ListRoute53Records(zoneID, pattern)
	for _, record := range recordsList {
		if utils.SliceExists(recordTypes, aws.StringValue(record.Type)) {
			fmt.Println(aws.StringValue(record.Name) + " " + aws.StringValue(record.Type))
			err := client.ChangeRoute53Record(zoneID, record, aws.String("DELETE"))
			if err != nil {
				return err
			}
		}

	}
	return nil
}

// ChangeRoute53Record delete a single route53 record
func (client *Client) ChangeRoute53Record(zoneID *string, record *route53.ResourceRecordSet, action *string) error {
	_, err := client.Route53.ChangeResourceRecordSetsWithContext(client.Context, &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: zoneID,
		ChangeBatch: &route53.ChangeBatch{
			Changes: []*route53.Change{
				{
					Action:            action,
					ResourceRecordSet: record,
				},
			},
		},
	})

	return err
}

// CreateRoute53Zone create route53 hosted zone
func (client *Client) CreateRoute53Zone(name string, private bool, vpcs ...*route53.VPC) (*route53.HostedZone, error) {
	var vpc *route53.VPC
	if len(vpcs) > 0 {
		vpc = vpcs[0]
	}

	output, err := client.Route53.CreateHostedZoneWithContext(client.Context, &route53.CreateHostedZoneInput{
		CallerReference: aws.String(name),
		Name:            aws.String(name),
		HostedZoneConfig: &route53.HostedZoneConfig{
			PrivateZone: aws.Bool(private),
		},
		VPC: vpc,
	})
	if err != nil {
		return nil, err
	}

	return output.HostedZone, nil
}

// DeleteRoute53Zone delete specific hosted zone base on id
func (client *Client) DeleteRoute53Zone(id *string) error {
	_, err := client.Route53.DeleteHostedZoneWithContext(client.Context, &route53.DeleteHostedZoneInput{
		Id: id,
	})
	return err
}
