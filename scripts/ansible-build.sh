#! /bin/bash

# PJC = Project C.  Trying to design template so you can do quick search and replace based on the project.

ANSIBLE_BIN = $(which ansible-playbook)

if [ ! "$ANSIBLE_BIN" ]; then
   echo 
   echo 
   echo  "ansible_playbook not found, try sourcing your virtualenv."
   echo  
   echo "Example: source venv/bin/activate"
   echo 
   echo -1 
fi


ROLE=$1
ENV=$2 #Project C used ${2-QA}
TAG=$3

# ANSIBLE_VAULT_PASSWORD_FILE is automatically utilized by ansible
# without needing a command line flag.  vault_password.sh is a script 
# that returns either the content of VAULT_PASSWORD (for jenkins) or the 
# content of the file ~/.ansible_vault.txt
export 	ANSIBLE_VAULT_PASSWORD_FILE='vault_password.sh'


# Need to use the key-pair for this usr
# Expect HHS_PJC_KEYPAIR to be defined
if [ -f ~/.my-devops.rc ]; then
	source ~/.my-devops.rc 
fi

if [ "$ROLE" ==  -o "X$ROLE" == "X" ]; then
	echo 
	echo "Usage: $0 <role> <[env]> <[tag]>"
	echo "Role should be <enter text based on project>"
	echo
	echo "Role is required. Env defaults to QA."
	echo 
	echo "Role is required. Env defaults to QA."
	echo
	echo "Tag is optional, deffaults to null."
	echo
	echo "Capitalization is significant."
	echo
	exit 0
fi

ANSIBLE_TAG_ARG=''
if [ "X$TAG" != "X" ]; then
	ANSIBLE_TAG_ARG="-e 'tag=${TAG}'"
fi

if [ "X$HHS_PJC_KEYNAME" == "X" ]; then
	echo
	echo
	echo "KEYS KEYS KEYS.  This depends on how we allow access to AWS API"
	echo
	echo "Uses temporary key based on user."
	echo
	echo "It must be the key pair defined in the IAM AWS console"
	echo
	echo
	exit -1
fi

eval $ANSIBLE_BIN -e "env=${ENV}" -e "exec_mode=build" -e "key_name=${HHS_PJC_KEYNAME}" ${ANSIBLE_TAG_ARG} \
	${EXT_VARS_ARG} ANSIBEL/${ROLE}-AMI.yml

#MAYBE re-write
#$DEBUG eval $ANSIBLE_BIN -e "env=${ENV}" -e "exec_mode=build" -e "key_name=${HHS_PJC_KEYNAME}" 
