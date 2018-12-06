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

PARAM=SSHKEY

echo "ParameterKey=$PARAM,ParameterValue=\"$SSHKEY_NAME\"\
ParameterKey=$PARAM2,ParameterValue=\"$ENV\"\
	lskdjfljds"

# creates ec2 instance, configure nginx and pull StaticSite from s3
# create-stack.sh cf-sand-autoscale "ParameterKey=$PARAM,ParameterValue=\"$SSHKEY_NAME\""

# creates listener and target group
#create-stack.sh cf-sand-autoscale-tgroup
