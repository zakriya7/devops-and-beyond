#!/bin/bash

# this does not remove any existing entries.  It only adds another rule

myip=$(curl http://checkip.amazonaws.com/)

groupName=$1
#groupName=mgt-sg
#groupName=bastion-sg

echo $myip

# aws cli command to set ip for bastion-sg
# can change so sg is a variable.

securityGroupId=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$groupName --query 'SecurityGroups[*].[GroupId]' --out text) 

$DEBUG aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 22 --cidr "$myip/32"
