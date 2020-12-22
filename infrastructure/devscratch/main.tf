module "all-resources" {
  source = "../shared"
  api_vpc_id = "vpc-0e81f3bdc6ee6ec6e"
  api_vpc_cidr = "10.120.12.0/24"
  api_subnets = [
    "subnet-075c844707f98cba3",
    "subnet-0b80baa7e9b845c9a"                                                                                                                                                            

  ]
  bastion_security_group = "sg-0525e1742fc163c02"
}
