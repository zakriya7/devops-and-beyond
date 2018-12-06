#!/bin/bash
#DEBUG=echo

# set script home
#SCRIPT_HOME=$(pwd)
SCRIPT_HOME=$(pwd)
STACK_NAME="$1"
PARAMS=$2

if [ "X${STACK_NAME}" == "X" ]; then 
       echo "please provide stackname"	
       exit;
fi

# Parameters not required because defaults are defined

#### THIS --capabilities CAPABILITY_IAM is required to make the stack work because CF is creating IAM resources
$DEBUG aws cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://${SCRIPT_HOME}/${STACK_NAME}.yml \
	--parameters $PARAMS \
	--capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM
# wait for all resources to finish.  This is important for tieing scripts together.

$DEBUG aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME}
