#!/bin/bash

# returns instance id for running instances......
#aws ec2 describe-instance-status --query InstanceStatuses[*].InstanceId
SCRIPTS=/home/david/git/awsandbeyond/devopslab/scripts

python3 $SCRIPTS/lsRunningEc2.py
