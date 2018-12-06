# AWS_STATIC

## Overview.  

The aws-static labs focus on the provisioning of AWS devops models to provivision static site across different hosting models:

### Static Hosting LABS

1. aws-twonode: Creates two node nginx servers.  
2. aws-autoscale: This uses autoscaling groups to create EC2 instances
3. aws-s3: This lab uses serverless static hosting
4. aws-containers: This adds security to the labs.  I have not completed this yet.

### File layout

- master-create scripts provide the details for stack dependancy's.  These scripts create the whole stack.
- master-delete scripts delete the whole stack.
- Read the .yml for what the scripts are doing.
- Best explaination for AWS components is AWS documents themselves.

### set lab env (PATH) by adding the lab.env in your login
`echo "source ~/git/devopslab/scripts/lab.env" >>~/.bash_profile`

### Now set your environment by running the source command.
`source ~/.bash_profile`  

You only need to source your .bash_profile when you make an edit and need the changed to reflect in your environment

bash reads the .bash_profile everytime you login.

### Configure awscli.  
[ec2-user@ip-172-16-1-188 scripts]$ aws configure  
AWS Access Key ID [None]:  
AWS Secret Access Key [None]:  
Default region name [None]: us-east-1  
Default output format [None]: json  

**This creates the aws files under the user home.   ~/.aws/config and ~/.aws/cred files. **

### To test your configuration type:

`aws ec2 describe-instances`  
`aws s3 l`
