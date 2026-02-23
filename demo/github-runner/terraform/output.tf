output "vpc_id" {
  value = var.vpc_id != "" ? var.vpc_id : module.vpc[0].vpc_id
}

output "private_subnets" {
  value = var.vpc_id != "" ? data.aws_subnets.existing[0].ids : module.vpc[0].private_subnets
}