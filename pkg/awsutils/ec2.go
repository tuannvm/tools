package awsutils

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
)

// GetDefaultVPC retrieve default vpc of specific region and return
func (client *Client) GetDefaultVPC() (*ec2.Vpc, error) {
	req := &ec2.DescribeVpcsInput{
		Filters: []*ec2.Filter{
			{
				Name:   aws.String("isDefault"),
				Values: aws.StringSlice([]string{"true"}),
			},
		},
	}

	resp, err := client.EC2.DescribeVpcsWithContext(client.Context, req)
	if err != nil {
		return nil, err
	}
	return resp.Vpcs[0], nil
}
