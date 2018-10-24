package awsutils

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/aws/aws-sdk-go/service/iam"
	"github.com/aws/aws-sdk-go/service/route53"
)

// Config struct type
type Config struct {
	AccessKey, SecretKey, Region string
}

// Client struct type
type Client struct {
	EC2     *ec2.EC2
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
	ec2 := ec2.New(sess)
	return &Client{
		IAM:     iam,
		Route53: route53,
		EC2:     ec2,
		Context: ctx,
	}
}
