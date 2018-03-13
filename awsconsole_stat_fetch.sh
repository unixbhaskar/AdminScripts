#!/bin/bash

###############################################################################################################################
# This script is to fetch the instance id , corresponding EIP (Elastic IP) and the current status of the instance.The data    #
# Will be fecthed from the AWS console using access key and the secret key. This extracted data will get stored in a          #
# flat file and the naming convention will be Region_Instance_details_Date&time.txt .This file will get stored in the local   #
# folder.                                                                                                                     #
###############################################################################################################################

## Store the current date & time

now="$(date)"
printf "\n Collecting instance details.. $now, Please wait ***\n"




## Credentials (Access key /Secret key) based on regions)

## APAC Region Keys

AP_AWS_ACCESS_KEY_ID=
AP_AWS_SECRET_KEY_ID=
AP_REGION_NAME=ap-southeast-1
EC2_URL=https://ap-southeast-1.ec2.amazonaws.com


### EU Region Keys

EU_AWS_ACCESS_KEY_ID=
EU_AWS_SECRET_KEY_ID=
EU_REGION_NAME=eu-west-1
EC2_URL=https://eu-west-1.ec2.amazonaws.com



### US Region  Keys

US_AWS_ACCESS_KEY_ID=
US_AWS_SECRET_KEY_ID=
US_REGION_NAME=us-east-1
EC2_URL=https://us-east-1.ec2.amazonaws.com


## Fetch details for AP Region
## $AP_AWS_ACCESS_KEY => holds the APAC Region Access key and $AP_AWS_SECRET_KEY=> holds the APAC region secret key 
## fetches the instance id, Elastic IP address and the Current status of the instance

ec2din  --aws-access-key $AP_AWS_ACCESS_KEY_ID  -W $AP_AWS_SECRET_KEY_ID --url $EC2_URL --region $AP_REGION_NAME | grep 'INSTANCE' |  grep -v 'stopped' | cut  -f 2,7,6,14,15,17 | gawk -F=  ' { print $1 $2 $3 $4 $5 $6 }' > $HOME/AP_INSTANCE_DETAILS.txt


## Fetch details for the EU region
ec2din  --aws-access-key $EU_AWS_ACCESS_KEY_ID  -W $EU_AWS_SECRET_KEY_ID --url $EC2_URL --region $EU_REGION_NAME | grep 'INSTANCE' | grep -v 'stopped' | cut  -f 2,7,15,6,14,15,17 | gawk -F=  ' { print $1 $2 $3 $4 $5 $6 }' > $HOME/EU_INSTANCE_DETAILS.txt

## Fetch details for the US Region
ec2din  --aws-access-key $US_AWS_ACCESS_KEY_ID  -W $US_AWS_SECRET_KEY_ID --url $EC2_URL --region $US_REGION_NAME  | grep 'INSTANCE' | grep -v 'stopped' | cut  -f 2,7,15,6,14,15,17 | gawk -F= ' { print $1 $2 $3 $4 $5 $6 }' > $HOME/US_INSTANCE_DETAILS.txt


printf "\n\n\n **Completed....\n"

