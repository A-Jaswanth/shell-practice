#!/bin/bash
AMIID="ami-0220d79f3f480ecf5"
ZONE_ID="Z06698413354I1O4605CI"
domainname="daws90.online"
for instance in $@
do 
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id $AMIID \
        --instance-type t3.micro \
        --security-groups $instance \
	    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' \
	    --query 'Instances[0].InstanceId' \
        --output text)

    if [ $instance == frontend ];then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
         --query 'Reservations[*].Instances[*].PublicIpAddress' \
         --output text)
        route53=$domainname
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
         --query 'Reservations[*].Instances[*].PrivateIpAddress' \
         --output text
        )
        route53=$instance.$domainname
    fi 
         #### Updating R53 Record ####
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
        {
            "Comment": "Update A record to new IP",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "'$route53'",
                        "Type": "A",
                        "TTL": 1,
                        "ResourceRecords": [
                            {
                                "Value": "'$IP'"
                            }
                        ]
                    }
                }
            ]
        }
    '

done