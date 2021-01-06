## Create
doctl compute droplet create --image docker-20-04 --region sgp1 --size s-1vcpu-1gb --ssh-keys 22982194 --user-data-file user_data.txt test

## List
doctl compute droplet list

## Delete
doctl compute droplet delete test
