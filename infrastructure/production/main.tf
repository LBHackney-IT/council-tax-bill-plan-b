module "all-resources" {
  source = "../shared"

  stage        = "production"
  api_vpc_id   = "vpc-0d4b3dc0580b7f864"
  api_vpc_cidr = "10.120.8.0/24"
  api_subnets = [
    "subnet-01d3657f97a243261",
    "subnet-0b7b8fea07efabf34"
  ]
  bastion_security_group = "sg-071be695e594e8d2f"
}

output "database_port" {
  value = module.all-resources.database_port
}

output "database_host" {
  value = module.all-resources.database_host
}

output "database_username" {
  value = module.all-resources.database_username
}

output "database_password" {
  value     = module.all-resources.database_password
  sensitive = true
}
