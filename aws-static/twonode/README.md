# Two node labs

## Overview

The two-node lab uses redundant nginx server to host statid web sites. This configuration is highly available, but not cost effective.  

## Labs 
 
- Implment scripts to create sample environment.
- See DEVOPSTASKS.md and to add the various devops components.
  - CLI
  - Cloudformation
  - Ansible
  - Containers.
- Build Deployment Stack  
  - Codecommit
  - Codebuild
  - Codepline

### The lab creates two nginx servers behind and ELB as follows:

            Internet
                |             
                |
               ELB
              /   \
             /     \
         nginx1   nginx2
       amz-linux amz-linux
        aws ec2   aws ec2

### Sample site is pulled from shared s3 bucket.

## LAB ASSIGNMENT AND GOALS

### Review the scripts and create the infrastructure 

1. Read the master-create-twonode.sh

2. Run the master-create-twonode.sh

3. Test the htlm pages.  

- nginx1 IP: Obtain the IP of nginx1 and enter it in your browser.  
 Example  http://145.23.45.123  
This should return the sample site.  

- nginx2 obtain the IP of nginx1 and enter it in your browser. 

  - `http://<your-ip>`  
     Example  http://145.23.45.123  
     This should return the sample site.  

4. Test going through the ELB
- Find the external DNS name for your elb and put that in your browser.
http://<elb dns>  
This should return SampleSite.

5. Test server.html
- ngin1   http://<nginx1-ip>/server.html
Should return server1.html

- ngin2   http://<nginx1-ip>/server.html
Should return server2.html

- elb
http://<elb dns>/server.html  
keep hitting refresh and it should round robbing server1.html and server2.html 

