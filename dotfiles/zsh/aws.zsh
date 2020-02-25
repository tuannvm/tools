function kip() {
  aws ec2 describe-instances --filters "Name=instance-id ,Values=*$1*" --query "Reservations[].Instances[].NetworkInterfaces[].[Association.PublicIp,PrivateIpAddress]"
}
