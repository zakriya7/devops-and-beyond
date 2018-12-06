# DEVOPSANDBEYOND

## SEE LAB-SETUP.md to start labs.

- Set-up awscli on local workstation.  Labs require a bash environment.
- Configure you aws keys.


## Student Pre-requisites

These labs are intermediate to advanced.   Studenst need a solid understanding of AWS, Linux, Networking

## Lab Overview

This repository focuses on different devops models. The goal is to provide the student with enough real world DevOps skills that they can apply them to actual projects.  The approach is to use  simplified application and database stacks allowing the student to focus on the devops models.

## Students GIT repository.

Curently the labs are designed for students to copy this repository to their own git repo and perform the labs in their own repostiory.

## Lab list

   __All Labs Depend on aws-vpc__

- aws-sand-vpc:  This Lab creates the sandbox vpc.  __It is required for the other labs__
- aws-static: Simple static web site that progresses to using ALB's and autoscaling groups.
- aws-rest-api-python: rest based apis using various platforms including serverless.
- files:  This contains files needed for the labs for example the HTML for the web site.
- scripts: This contains scripts used help automate the environment.  

## LAB.md

This contains the directions for the students.  Each folder has their own LAB.md file.  

## Additional Repos

- development contains application development code. This repo emulates the software development teams repo, but with basic funtionalitly
- secdevops contains prod vpc, secure ami builds and other security related items for the platform

## LABS in draft state.

Labs with a -draft are being written.  They should are included to give students a roadmap into the next labs.

## Naming Convention for files.

Cloudformation STACK NAME: Use the name of the file without the .yml extensions when creating the stack.

- EXAMPLE: cf-sand-vpc.yml stack name is cf-vpc-sand  

Ansible files: ans-sand-vpc.yml

Terraform: ter-sand-vpc.tf # terraform files end in tf and have their own format
