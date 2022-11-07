variable "vpc_cidr_block" {
  description = "The main cider block for our vpc"
  default = "10.0.0.0/16"
}
variable "east_Availability_Zones" {
  type = list
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "public_subnets_cidr_blocks" {
  description = "Public_subnets cider blocks"
  type = list
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]
}

variable "Privet_subnets_cidr_blocks" {
  description = "Privet subnets cider blocks"
    type = list

  default = [
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

