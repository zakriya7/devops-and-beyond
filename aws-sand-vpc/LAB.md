# labs for this section.  

Unless otherwise noted use t2.micro.

## Lab Excersize (CLOUDFORMATION)
- Modify vpc and add subTL3 AZ
-  Merge the three cloudformation scripts into one script.

## Ansible Assignment (requires ANSIABLE lab) 

- Create the ans-master-create.sh script and repace aws cli create stack with ansible create stack scripts. 


## AWS Networking: MANUALLY  Configure vpc peering between the default vpc and the SAND vpc

- Using the console configure vpc peering between the default vpc and the SAND vpc.
- Manually create and ec2 instance in defaul vpc. Create/Assign it default-bastion-sg.
   - Security Group should allow just your IP to ssh to server
   - MAKE SURE PUBLIC IP WHEN BUILDING AMI.
   - Allow default-bastion to ssh to the sand-bastion. SET-UP SSH
      - Public ssh key for ec2-user (or your user) needs to go into $HOME/.ssh/ folder on the SAND bastion
      - Pricate ssh key for ec2-user (or your user) needs to go into $HOME/.ssh/ folder on the default bastion

As per all projects: READ the scripts to see what they are doing.  They are fairly easy to read  
and students should be able to follow the code at this point.  

