#!/bin/bash
#DEBUG=echo

# set script home
SCRIPT_HOME=$(pwd)
STACK_NAME="$1"

if [ "X${STACK_NAME}" == "X" ]; then 
       echo "please provide stackname"	
       exit;
fi


$DEBUG aws cloudformation delete-stack --stack-name $STACK_NAME

$DEBUG aws cloudformation wait stack-delete-complete --stack-name ${STACK_NAME}
