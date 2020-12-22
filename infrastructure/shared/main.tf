variable "api_vpc_id" {
  type = string
  description = "The VPC ID"
}

variable "api_vpc_cidr" {
  type = string
  description = "The cidr block for the vpc"
}

variable "api_subnets" {
  type = list(string)
  description = "A list of subnet ids for the database to attach to"
}

variable "bastion_security_group" {
  type = string
  description = "The id of the bastion security group for access to the database"
}

resource "aws_security_group" "council_tax_bill_plan_b" {
  name        = "council-tax-bill-plan-b"
  description = "Allow bastion access to db"
  vpc_id      = var.api_vpc_id

  ingress {
    description = "Allow traffic from Bastion security group"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      var.bastion_security_group
    ]
  }

  ingress {
    description = "Allow all local traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.api_vpc_cidr
    ]
  }

  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "database" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name                            = "council-tax-bill-plan-b"

  engine                          = "aurora-postgresql"
  engine_version                  = "11.9"

  vpc_id                          = var.api_vpc_id
  subnets                         = var.api_subnets

  replica_count                   = 1
  allowed_security_groups         = [aws_security_group.council_tax_bill_plan_b.id]
  allowed_cidr_blocks             = [var.api_vpc_cidr]
  instance_type                   = "db.t3.medium"
  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10

  #db_parameter_group_name         = "default"
  #db_cluster_parameter_group_name = "default"

  enabled_cloudwatch_logs_exports = ["postgresql"]
}
