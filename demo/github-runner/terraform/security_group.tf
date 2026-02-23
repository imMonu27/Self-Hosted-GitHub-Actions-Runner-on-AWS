resource "aws_security_group" "runner_sg" {
  name        = "runner-sg"
  description = "Allow SSH"
  vpc_id      = var.vpc_id != "" ? var.vpc_id : module.vpc[0].vpc_id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
