package awsutils

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/iam"
	"github.com/aws/aws-sdk-go/service/route53"
	"github.com/tuannvm/tools/pkg/utils"
)

// Config struct type
type Config struct {
	AccessKey, SecretKey, Region string
}

// Client struct type
type Client struct {
	IAM     *iam.IAM
	Route53 *route53.Route53
	Context aws.Context
}

// NewConfig create *aws.Config to use with session
func NewConfig(config *Config) *aws.Config {
	// combine many providers in case some is missing
	creds := credentials.NewChainCredentials([]credentials.Provider{
		// use static access key & private key if available
		&credentials.StaticProvider{
			Value: credentials.Value{
				AccessKeyID:     config.AccessKey,
				SecretAccessKey: config.SecretKey,
			},
		},
		// fallback to default aws environment variables
		&credentials.EnvProvider{},
		// read aws config file $HOME/.aws/credentials
		&credentials.SharedCredentialsProvider{},
	})

	awsConfig := aws.NewConfig()
	awsConfig.WithCredentials(creds)
	awsConfig.WithRegion(config.Region)

	return awsConfig
}

// New create *iam client from specific *aws.Config
func New(awsConfig *aws.Config) *Client {
	ctx := aws.BackgroundContext()
	sess := session.Must(session.NewSession(awsConfig))
	iam := iam.New(sess)
	route53 := route53.New(sess)
	return &Client{
		IAM:     iam,
		Route53: route53,
		Context: ctx,
	}
}

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
	return nil, nil
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
			err := client.DeleteRoute53Record(zoneID, record)
			if err != nil {
				return err
			}
		}

	}
	return nil
}

// DeleteRoute53Record delete a single route53 record
func (client *Client) DeleteRoute53Record(zoneID *string, record *route53.ResourceRecordSet) error {
	_, err := client.Route53.ChangeResourceRecordSetsWithContext(client.Context, &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: zoneID,
		ChangeBatch: &route53.ChangeBatch{
			Changes: []*route53.Change{
				{
					Action:            aws.String("DELETE"),
					ResourceRecordSet: record,
				},
			},
		},
	})

	return err
}
