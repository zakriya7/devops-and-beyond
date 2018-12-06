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
PARAM=SSHKEY

echo "ParameterKey=$PARAM,ParameterValue=\"$SSHKEY_NAME\""

# creates ec2 instance, configure nginx and pull StaticSite from s3
create-stack.sh cf-sand-twonode-nginx-config "ParameterKey=$PARAM,ParameterValue=\"$SSHKEY_NAME\""

# Create ELB
create-stack.sh cf-sand-twonode-elbv2

# creates listener and target group
create-stack.sh cf-sand-twonode-tgroup
