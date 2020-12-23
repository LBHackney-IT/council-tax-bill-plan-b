module "all-resources" {
  source = "../shared"
  api_vpc_id = "vpc-0662f3f3759795b33"
  api_vpc_cidr = "10.120.6.0/24"
  api_subnets = [
    "subnet-000b89c249f12a8ad",
    "subnet-0deabb5d8fb9c3446"
  ]
  bastion_security_group = "sg-073fee129434a7e0c"
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

