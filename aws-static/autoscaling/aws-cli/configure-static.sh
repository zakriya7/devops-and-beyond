#!/bin/bash
sudu su -
yum -y update
amazon-linux-extras install nginx1.12
systemctl enable nignx
service nginx start
# NOT SURE THIS WORKS
cat >> ~/.aws/conf << EOF
[default]
region = us-east-1
EOF

cd /usr/share/nginx/html/
SERVER=$(hostname)
echo "$SERVER" >server.html  
#  MAKE SURE EC2 HAS AN IAM ROLE
aws s3 cp s3://devopsandbeyond2018/ . --recursive
