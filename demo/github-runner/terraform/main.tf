terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"

    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  count  = var.vpc_id == "" ? 1 : 0
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name               = var.vpc.name
  cidr               = var.vpc.cidr
  azs                = var.vpc.azs
  private_subnets    = var.vpc.private_subnets
  public_subnets     = var.vpc.public_subnets
  enable_nat_gateway = var.vpc.enable_nat_gateway
  enable_vpn_gateway = var.vpc.enable_vpn_gateway
  tags               = var.vpc.tags
}

data "aws_vpc" "existing" {
  count = var.vpc_id != "" ? 1 : 0
  id    = var.vpc_id
}

data "aws_subnets" "existing" {
  count = var.vpc_id != "" ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  selected_vpc_id = var.vpc_id != "" ? data.aws_vpc.existing[0].id : module.vpc[0].vpc_id
}



module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.3.1"


  name                      = var.asg.name
  min_size                  = var.asg.min_size
  max_size                  = var.asg.max_size
  desired_capacity          = var.asg.desired_capacity
  vpc_zone_identifier       = var.vpc_id != "" ? data.aws_subnets.existing[0].ids : module.vpc[0].private_subnets
  launch_template_name      = var.asg.launch_template_name
  launch_template_version   = var.asg.launch_template_version
  image_id                  = var.ami
  instance_type             = var.asg.instance_type
  iam_instance_profile_name = aws_iam_instance_profile.ssm_profile.name
  security_groups           = [aws_security_group.runner_sg.id]

  user_data = base64encode(<<-EOF
#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

cd /home/ec2-user/actions-runner

# Manually install Dotnet Core 6.0 dependencies 
sudo dnf install -y icu krb5-libs libgcc libstdc++ openssl-libs zlib

# Optional fallback
# sudo ./bin/installdependencies.sh || true

GH_PAT="${var.github_pat}"

REG_TOKEN=$(curl -s -X POST \
  -H "Authorization: token $GH_PAT" \
  https://api.github.com/repos/rozettatechnology/datahex/actions/runners/registration-token | jq -r .token)

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)



sudo -u ec2-user ./config.sh --url https://github.com/rozettatechnology/datahex \
            --token $REG_TOKEN \
            --name "runner-$INSTANCE_ID" \
            --labels "dhx-runbook-runner-$INSTANCE_ID" \
            --unattended 
    
sudo ./svc.sh install 
sudo ./svc.sh start


EOF
  )
  instance_refresh = var.asg.instance_refresh
  tags             = var.asg.tags
}


