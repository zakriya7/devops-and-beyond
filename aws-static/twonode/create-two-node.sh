#!/bin/bash

# Steps are designed to be copied and pasted.

# Steps

# Set vpc-id
export vpcid=$(aws ec2 describe-vpcs --filter Name=tag-value,Values=vpc-sand --query "Vpcs[*].VpcId" --out text)
echo "vpcid: "$vpcid

# Create nginx-sg security group. This returns sg id which is used for next script.
 nginxsgid=$(aws ec2 create-security-group --group-name nginx-sg --description "base security group for nginx-sg" --vpc-id $vpcid --query 'GroupId' --output text)
 aws ec2 create-tags --resources $nginxsgid --tags Key=Name,Value=nginx-sg
# nginxsgid=$(aws ec2 describe-security-groups --filters Name=group-name,Values=nginx-sg --query 'SecurityGroups[*].[GroupId]' --out text)
echo "nginxsgid: "$nginxsgid

# Create tl-elb-sg security group. This returns sg id which is used for next script.
 tlelbsg=$(aws ec2 create-security-group --group-name tl-elb-sg --description "base security group for tl-elb-sg" --vpc-id $vpcid --query 'GroupId' --output text)
 aws ec2 create-tags --resources $tlelbsg --tags Key=Name,Value=tl-elb-sg
echo "tlelbsg: "$tlelbsg

# GRAB bastion-sg security group
 bastionsg=$(aws ec2 describe-security-groups --filters Name=group-name,Values=bastion-sg --query 'SecurityGroups[*].[GroupId]' --out text)
echo "bastionsg:" $bastionsg

#  Authorize elb to access the nginx server.
#=aws ec2 authorize-security-group-ingress --group-id $nginxsgid --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $nginxsgid --protocol tcp --port 22 --source-group $bastionsg
aws ec2 authorize-security-group-ingress --group-id $nginxsgid --protocol tcp --port 80 --source-group $tlelbsg

#  Authorize world to elb for 80 and 443
aws ec2 authorize-security-group-ingress --group-id $tlelbsg --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $tlelbsg --protocol tcp --port 443 --cidr 0.0.0.0/0

# SubnetID's
# Returns all subnet ids that use SubTL in its name for VPC
export SubTL=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$vpcid "Name=tag-value,Values=SubT*" --query "Subnets[0].SubnetId" --out text)
export SubTL2=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$vpcid "Name=tag-value,Values=SubT*" --query "Subnets[1].SubnetId" --out text)

## Create instance.  Not intuitive called run-instances
# nginx1
 nginx1id=$(aws ec2 run-instances --image-id ami-0922553b7b0369273 --count 1 --instance-type t2.micro --key-name devopsandbeyond --security-group-ids $nginxsgid \
	--subnet-id $SubTL --query 'Instances[0].InstanceId' --output text)
 aws ec2 create-tags --resources $nginx1id --tags Key=Name,Value=nginx-1

 nginx2id=$(aws ec2 run-instances --image-id ami-0922553b7b0369273  --count 1 --instance-type t2.micro --key-name devopsandbeyond --security-group-ids $nginxsgid \
	--subnet-id $SubTL2 --query 'Instances[0].InstanceId' --output text)
 aws ec2 create-tags --resources $nginx2id --tags Key=Name,Value=nginx-2

echo "nginx1id: " $nginx1id
echo "nginx2id: " $nginx2id

# Create ELB's and Listeners.
elbarn=$(aws elbv2 create-load-balancer --name tl-elb --subnets $SubTL $SubTL2 --security-groups $tlelbsg \
	--scheme internet-facing --query 'LoadBalancers[*].LoadBalancerArn' --out text )
echo "elbarn: "$elbarn

tgarn=$(aws elbv2 create-target-group --name nginx-tg --protocol HTTP --port 80 --vpc-id $vpcid --query "TargetGroups[*].TargetGroupArn" --out text 2>/dev/null)
echo "tgarn: "$tgarn

lsnrarn=$(aws elbv2 create-listener --load-balancer-arn $elbarn --protocol HTTP --port 80  --default-actions Type=forward,TargetGroupArn=$tgarn --out text)
echo "lsnrarn: " $lsnrarn

#### REGISTER INSTANCES.
#ec2Id=$(aws ec2 describe-instances --filter Name=tag:Name,Values=nginx-1 --query 'Reservations[*].Instances[*].InstanceId' 2>/dev/null)
#aws elbv2 register-targets --target-group-arn $tgId  --targets Id=$ec2Id

#discover instances to attach
ec2Id=$(aws ec2 describe-instances --filter Name=tag:Name,Values=nginx* --query 'Reservations[*].Instances[*].InstanceId' --out text)
for instance in $ec2Id
do
echo "Registering $instance" 
$DEBUG aws elbv2 register-targets --target-group-arn $tgarn  --targets Id=$instance
done

############configure nginx and ssh to hosts
bastionIP=$(aws ec2 describe-instances --filter Name=tag:Name,Values=sand-bastion --query 'Reservations[*].Instances[*].PublicIpAddress' --out text)

## Copy SampleSite to nginx servers
# SampleSite.zip is under AWS-ASSOC/files
# cd to where your files are
# Replace with your home directory.
FILE=/home/<YOUR HOME>/git/awsandbeyond/devopslab/files/SampleSite.zip

# Configure bastion host.
bastionIP=$(aws ec2 describe-instances --filter Name=tag:Name,Values=sand-bastion --query 'Reservations[*].Instances[*].PublicIpAddress' --out text)
scp -i ~/.ssh/devopsandbeyond.pem  $FILE ec2-user@"$bastionIP":
scp -i ~/.ssh/devopsandbeyond.pem  ~/.ssh/devopsandbeyond.pem ec2-user@"$bastionIP":~/.ssh/
ssh -i ~/.ssh/devopsandbeyond.pem  ec2-user@$bastionIP "chmod 600 ~/.ssh/*"
ssh -i ~/.ssh/devopsandbeyond.pem  ec2-user@$bastionIP "ls -l ~/.ssh"

# Have to copy from bastion.
# log onto bastion host
ssh -i ~/.ssh/devopsandbeyond.pem  ec2-user@$bastionIP 

# configure aws cli

[ec2-user@ip-172-16-1-89 ~]$ aws configure
AWS Access Key ID [None]:
AWS Secret Access Key [None]:
Default region name [None]: us-east-1
Default output format [None]: json

##
nginx1IP=$(aws ec2 describe-instances --filter Name=tag:Name,Values=nginx-1 --query 'Reservations[*].Instances[*].PrivateIpAddress' --out text)
nginx2IP=$(aws ec2 describe-instances --filter Name=tag:Name,Values=nginx-2 --query 'Reservations[*].Instances[*].PrivateIpAddress' --out text)

# Copy SampleSite to NGINX1 and NGINX2
# From ec2-user home
scp -i ~/.ssh/devopsandbeyond.pem SampleSite.zip ec2-user@"$nginx1IP":
scp -i ~/.ssh/devopsandbeyond.pem SampleSite.zip ec2-user@"$nginx2IP":

# confirm copy
ssh -i ~/.ssh/devopsandbeyond.pem ec2-user@"$nginx1IP" ls
ssh -i ~/.ssh/devopsandbeyond.pem ec2-user@"$nginx2IP" ls

# INSTALL AND CONFIGURE NGINX FROM EACH NGINX SERVER
# Install and configure nginx1.
sudo su
yum -y update
#yum -y install nginx 
amazon-linux-extras install nginx1.12
service nginx start
mv /home/ec2-user/SampleSite.zip /usr/share/nginx/html/
cd /usr/share/nginx/html/
unzip -o SampleSite.zip
#echo "Server 1" >server.html  #  Change to Server 2 for nginx-1
hostname >server.html  #  
curl localhost/server.html

# Repeat for Server 2 except change output to server.html
# CHANGE NUMBER FOR nginx2
echo "Server 1" >server.html  #  Change to Server 2 for nginx-1
curl localhost/server.html

# No connect through your browser.
# Find ELB DNS NAME
aws elbv2 describe-load-balancers



