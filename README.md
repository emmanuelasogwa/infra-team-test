# DevOps Technical Assessments
The Terraform configuration files contained in this repository will create the following resources:<br />
A VPC <br />
A highly available load balancer <br />
Private and public subnets --We want to deploy our applications in the private subnet for increased secuity<br />
EC2 instances which can scale horizontally depending on traffic this is achieved using Autoscaling allows he number of instances to scale up or down depending on traffic
Load balancer security group <br />
and security group for the Ec2 instances <br />
The target group which allows the load balancer to route traffic to multiple instances will be created <br />
Adding of new created instances to the target code will also be handled by code defined in the configuration files <br />


