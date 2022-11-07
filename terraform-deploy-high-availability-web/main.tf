# First we need aws  Provider

# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"

    }
  }
}

# Defined aws region 
provider "aws" {
  region =   "us-east-1"

}

# ------------------------------------------- Network section ----------------------------
## Create AWS VPC 
resource "aws_vpc" "High_availability_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "name" = "High_availability_VPC"
  }
}

## Crate internet getaway
resource "aws_internet_gateway" "High_availability_gw" {
  vpc_id = aws_vpc.High_availability_vpc.id
  tags = {
    "name" = "High_availability_gw"
  }
}

## Create public  subnets (1)
resource "aws_subnet" "Public_subnet_1" {
  vpc_id = aws_vpc.High_availability_vpc.id
  cidr_block = var.public_subnets_cidr_blocks[0]
  availability_zone = var.east_Availability_Zones[0]
  tags = {
    "name" = "Public subnet_1"
  }

}

## Create public  subnets (2)
resource "aws_subnet" "Public_subnet_2" {
  vpc_id = aws_vpc.High_availability_vpc.id
  cidr_block = var.public_subnets_cidr_blocks[1]
  availability_zone = var.east_Availability_Zones[1]
  tags = {
    "name" = "Public subnet_2"
  }
}


## Create Privet  subnets (1)
resource "aws_subnet" "Privet_subnet_1" {
  vpc_id = aws_vpc.High_availability_vpc.id
  cidr_block = var.Privet_subnets_cidr_blocks[0]
  availability_zone = var.east_Availability_Zones[0]
  tags = {
    "name" = "Privet_subnet_1 "
  }

}

## Create Privet  subnets (2)
resource "aws_subnet" "Privet_subnet_2" {
  vpc_id = aws_vpc.High_availability_vpc.id
  cidr_block = var.Privet_subnets_cidr_blocks[1]
  availability_zone = var.east_Availability_Zones[1]
  tags = {
    "name" = "Privet_subnet_2"
  }
}


## Create Nate gateway with Elastic_ip For Public subnet (1)
resource "aws_eip" "Elastic_ip_for_Public_subnet_1" {
  vpc = true

  associate_with_private_ip = "10.0.0.12"
  depends_on                = [aws_internet_gateway.High_availability_gw]
  tags = {
    "name" = "Elastic_ip_for_Public_subnet_1"
  }
}

resource "aws_nat_gateway" "Nat_gateway_public_subnet_1" {
  allocation_id = aws_eip.Elastic_ip_for_Public_subnet_1.id
  subnet_id     = aws_subnet.Public_subnet_1.id

  tags = {
    Name = "gw_NAT_public_subnet_2"
  }

  depends_on = [aws_internet_gateway.High_availability_gw]
}

## Create Nate gateway with Elastic_ip For Public subnet (2)
resource "aws_eip" "Elastic_ip_for_Public_subnet_2" {
  vpc = true
  associate_with_private_ip = "10.0.1.12"
  depends_on                = [aws_internet_gateway.High_availability_gw]
    tags = {
    "name" = "Elastic_ip_for_Public_subnet_2"
  }
}

resource "aws_nat_gateway" "Nat_gateway_public_subnet_2" {
  allocation_id = aws_eip.Elastic_ip_for_Public_subnet_2.id
  subnet_id     = aws_subnet.Public_subnet_2.id

  tags = {
    Name = "gw_NAT_public_subnet_2"
  }


  depends_on = [aws_internet_gateway.High_availability_gw]
}

#----------------------------------------------------------------------------