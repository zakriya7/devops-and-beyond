#!/bin/bash


DIR=`dirname $0`

if [ -z $1 ] || [ -z $2 ]
then
    echo "usage: Pass in BucketName and SSHKEY."
    echo "BucketNameStandard=  <first><last>awsandbeyond2018"
    echo "SSHKEY= Your EC2 SSH Key"
    exit 1
fi

#Need Name of the Bucket and Pass in paramters when using CLI.
BUCKET=$1
SSHKEY_NAME=$2
PARAM=BucketName
PARAM2=SSHKEY

echo "ParameterKey=$PARAM,ParameterValue=\"$BUCKET\""
echo "ParameterKey=$PARAM2,ParameterValue=\"$SSHKEY_NAME\""


# creates s3 bucket and security groups
create-stack.sh cf-sand-vpc "ParameterKey=$PARAM,ParameterValue=\"$BUCKET\""

# copy static site to s3
aws s3 cp ../files/SampleSite.zip s3://$BUCKET 
aws s3 ls s3://$BUCKET

# creates ec2 instance, configure nginx and pull StaticSite from s3
create-stack.sh cf-sand-iamroles

# Create ELB
create-stack.sh cf-sand-bastion "ParameterKey=$PARAM2,ParameterValue=\"$SSHKEY_NAME\""
