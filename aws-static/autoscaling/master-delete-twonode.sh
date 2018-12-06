#!/bin/bash

# deletes listener and target group
delete-stack.sh cf-sand-twonode-tgroup

# Create ELB
delete-stack.sh cf-sand-twonode-elbv2

# deletes ec2 instance, configure nginx and pull StaticSite from s3
delete-stack.sh cf-sand-twonode-nginx-config


