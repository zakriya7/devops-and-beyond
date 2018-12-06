#!/bin/bash
DIR=`dirname $0`

if [ -z $1 ] 
then
    echo "usage: Pass in SSHKEY."
    echo "SSHKEY= Your EC2 SSH Key"
    exit 1
fi

#Need Name of the Bucket and Pass in paramters when using CLI.
SSHKEY_NAME=$1
ENV=$2
VPCID=$3
SUBNETS=$4 #LIST 
ELBSG=$5
HCK=$6
ROLE=$7
BLDDATE=$8
FILE=$9
STACK_NAME=newstack

# creates ec2 instance, configure nginx and pull StaticSite from s3
# create-stack.sh cf-sand-autoscale "ParameterKey=$PARAM,ParameterValue=\"$SSHKEY_NAME\""

echo "aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://$FILE --parameters \
    ParameterKey=SSLCertificatename,ParameterValue=$SSHKEY_NAME \
    ParameterKey=EnvironmentName,ParameterValue=$ENV \
    ParameterKey=VpcId,ParameterValue=$VPCID \
    ParameterKey=Subnets,ParameterValue=$SUBNETS \
    ParameterKey=ELBSecurityGroups,ParameterValue=$ELBSG \
    ParameterKey=HealhCheckTarget,ParameterValue=$HCK \
    ParameterKey=Role,ParameterValue=$ROLE \
    ParameterKey=BuildDateTime,ParameterValue=$BLDDATE "
