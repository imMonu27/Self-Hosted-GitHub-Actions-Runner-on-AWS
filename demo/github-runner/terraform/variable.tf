variable "ami" {
  description = "The ID of the Amazon Machine Image (AMI) to use for launching EC2 instances in the Auto Scaling Group."
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token used for authenticating with the GitHub API to register self-hosted runners."
  type        = string
}

variable "region" {
  description = "The AWS region where the infrastructure will be deployed (e.g., us-east-1)."
  type        = string
}

variable "vpc" {
  description = "Configuration object for creating a new VPC. Required only when 'vpc_id' is not provided. Should include CIDR block, subnets, availability zones, and related settings."
  type        = any
}

variable "asg" {
  description = "Configuration object for the Auto Scaling Group, including details like desired capacity, instance type, launch template, and tags."
  type        = any
}

variable "vpc_id" {
  description = "The ID of an existing VPC to use. If specified, a new VPC will not be created and this VPC will be used instead."
  type        = string
}
