#!/bin/bash

DIR=`dirname $0`

if [ -z $1 ]
then
    echo "usage: Pass in name of your bucket.  <first><last>devopsandbeyond2018"
    exit 1
fi

BUCKET=$1

delete-stack.sh cf-sand-bastion

delete-stack.sh cf-sand-iamroles


# copy static site to s3
aws s3 rm s3://$BUCKET/ --recursive
aws s3 rb s3://$BUCKET
aws s3 ls 

# deletes s3 bucket and security groups
delete-stack.sh cf-sand-vpc

