# Creating and Managing autoscaling groups using the AWS CLI.


## Tasks

   - Step 1: Create a Launch Configuration
   - Step 2: Create an Auto Scaling Group
   - Step 3: Verify Your Auto Scaling Group
   - Step 4: (Optional) Delete Your Scaling Infrastructure


### Create a launce configuration 

__you can use a pre-build ami__

AMI=ami-0922553b7b0369273
mykeypair=devopsandbeyond
azs=us-east-1a, us-east-1b 
vpcSubnets=subnet-042abd76a76af092c subnet-0ce07aac96991c18f
tgArn="arn:aws:elasticloadbalancing:us-east-1:659381506705:targetgroup/cf-au-Targe-BVPZ8ZUO3D1W/485b15df12ba4dff"
secGroups=sg-0e59acc147e980e43

aws autoscaling create-launch-configuration --launch-configuration-name my-launch-config --key-name $mykeypair \
   --image-id $AMI --instance-type t2.micro --security-groups $secGroups --user-data file://configure-static.sh 

### Create auto-scaling group and use auto-scaling-configuration name.

aws autoscaling create-auto-scaling-group --auto-scaling-group-name my-auto-scaling-group --launch-configuration-name my-launch-config \
--min-size 1 --max-size 2 --desired-capacity 1 --vpc-zone-identifier subnet-0ce07aac96991c18f --target-group-arns $tgArn  #--availability-zones us-east-1a us-east-1b 
#--min-size 1 --max-size 2 desired-capacity 2 --vpc-zone-identifier $subnets
#--min-size 1 --max-size 3 --vpc-zone-identifier subnet-3345f91d, subnet-51780f5e,subnet-65a11102,subnet-77c30449,subnet-8eafeec4,subnet-a069dbfc

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name my-auto-scaling-group --force-delete

