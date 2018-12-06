#!/bin/bash

DIR=`dirname $0`

if [ -z $1 ] 
then
    echo "usage: Pass in ec2-id"
    exit 1
fi

ec2id=$1

$DEBUG aws ec2 start-instances --instance-ids $ec2id

