# Learn Terraform - Manage AWS Auto Scaling Groups

This repository contains Terraform conifguration files that can be used to configure and scale an Auto Scaling group. \
The Terraform configuration files contained in this repository will create the following resources:\
A VPC \
A highly available load balancer \
Private and public subnets --We want to deploy our applications in the private subnet for increased secuity\
EC2 instances \
Load balancer security group \
and security group for the Ec2 instances \
The target group which allows the load balancer to route traffic to multiple instances will be created \
Adding of new created instances to the target code will also be handled by code defined in the configuration files \


