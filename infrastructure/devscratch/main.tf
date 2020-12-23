module "all-resources" {
  source = "../shared"

  stage = "devscratch"
  api_vpc_id = "vpc-0e81f3bdc6ee6ec6e"
  api_vpc_cidr = "10.120.12.0/24"
  api_subnets = [
    "subnet-075c844707f98cba3",
    "subnet-0b80baa7e9b845c9a"                                                                                                                                                            

  ]
  bastion_security_group = "sg-0525e1742fc163c02"
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
  value = module.all-resources.database_password
  sensitive = true
}

