provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      infra-team-test = "aws-asg"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "main-vpc"
  cidr = "10.0.0.0/16"
  #for high availability we want to create a private subnet in all the azs in the chosen region
  #for high availability of ELB, it requires two public subnets
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.3.0/24", "10.0.2.0/24"]
  private_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

#Autoscaling Configuration
resource "aws_launch_configuration" "infra_test" {
  name_prefix     = "infra-team-test-"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = "t2.micro"
  key_name        = "testing"
  security_groups = [aws_security_group.infra_test_instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "infra_test" {
  name                 = "infra_test"
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.infra_test.name
  vpc_zone_identifier  = module.vpc.private_subnets
  target_group_arns    = [aws_lb_target_group.infra_test.arn]

  tag {
    key                 = "Name"
    value               = "Infrasture Team ASG - infra_test"
    propagate_at_launch = true
  }
}

resource "aws_lb" "infra_test" {
  name               = "infra-team-test-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.infra_test_lb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "infra_test" {
  load_balancer_arn = aws_lb.infra_test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.infra_test.arn
  }
}

resource "aws_lb_target_group" "infra_test" {
  name     = "infra-team-test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# Attach instances to target group
resource "aws_autoscaling_attachment" "infra_test" {
  autoscaling_group_name = aws_autoscaling_group.infra_test.id
  alb_target_group_arn   = aws_lb_target_group.infra_test.arn
}

resource "aws_security_group" "infra_test_instance" {
  name = "infra-team-test-instance"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.infra_test_lb.id]
  }
    ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.infra_test_lb.id]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "infra_test_lb" {
  name = "infra-team-test-lb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}
