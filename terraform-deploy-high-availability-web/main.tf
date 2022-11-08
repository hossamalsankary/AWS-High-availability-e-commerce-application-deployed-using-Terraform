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
  region = "us-east-1"

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
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.public_subnets_cidr_blocks[0]
  availability_zone = var.east_Availability_Zones[0]
  tags = {
    "name" = "Public subnet_1"
  }

}

## Create public  subnets (2)
resource "aws_subnet" "Public_subnet_2" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.public_subnets_cidr_blocks[1]
  availability_zone = var.east_Availability_Zones[1]
  tags = {
    "name" = "Public subnet_2"
  }
}


## Create Privet  subnets (1)
resource "aws_subnet" "Privet_subnet_1" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.Privet_subnets_cidr_blocks[0]
  availability_zone = var.east_Availability_Zones[0]
  tags = {
    "name" = "Privet_subnet_1 "
  }

}

## Create Privet  subnets (2)
resource "aws_subnet" "Privet_subnet_2" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.Privet_subnets_cidr_blocks[1]
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
  vpc                       = true
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



# Create Route Table resource with routes defined in-line for public subnets
resource "aws_route_table" "route_table_public_subnet_1" {
  vpc_id = aws_vpc.High_availability_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.High_availability_gw.id
  }


  tags = {
    Name = "public_route_public_subnet_1"
  }
}

resource "aws_route_table_association" "public_route_subnet_1" {
  subnet_id      = aws_subnet.Public_subnet_1.id
  route_table_id = aws_route_table.route_table_public_subnet_1.id
}

resource "aws_route_table" "route_table_public_subnet_2" {
  vpc_id = aws_vpc.High_availability_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.High_availability_gw.id
  }


  tags = {
    Name = "public_route_subnet_2"
  }
}

resource "aws_route_table_association" "public_route_subnet_2" {
  subnet_id      = aws_subnet.Public_subnet_2.id
  route_table_id = aws_route_table.route_table_public_subnet_2.id
}

# # Create Route Table resource with routes defined in-line for privet subnets

resource "aws_route_table" "route_table_privet_subnet_1" {
  vpc_id = aws_vpc.High_availability_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Nat_gateway_public_subnet_1.id
  }


  tags = {
    Name = "privet_route_subnet_1"
  }
}

resource "aws_route_table_association" "privet_route_subnet_1" {
  subnet_id      = aws_subnet.Privet_subnet_1.id
  route_table_id = aws_route_table.route_table_privet_subnet_1.id
}


resource "aws_route_table" "route_table_privet_subnet_2" {
  vpc_id = aws_vpc.High_availability_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Nat_gateway_public_subnet_2.id
  }


  tags = {
    Name = "privet_route_subnet_2"
  }
}

resource "aws_route_table_association" "privet_route_subnet_2" {
  subnet_id      = aws_subnet.Privet_subnet_2.id
  route_table_id = aws_route_table.route_table_privet_subnet_2.id
}
#----------------------------------------------------------------------------
## create secretly groups
resource "aws_security_group" "allow_web" {
  name        = "allow_web traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.High_availability_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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

  tags = {
    Name = "allow_web"
  }
}

# Creating Security Group for ELB
resource "aws_security_group" "ELB" {
  name        = "Demo Security Group"
  description = "Demo Module"
  vpc_id      = "${aws_vpc.High_availability_vpc.id}"# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }# HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create load balancer 
resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [aws_security_group.ELB.id]
  subnets = [
  aws_subnet.Public_subnet_1.id,
  aws_subnet.Public_subnet_2.id,
  ]
  cross_zone_load_balancing   = true
 health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
  }
resource "aws_launch_configuration" "web" {
  image_id               = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = "terraform"
   security_groups = [aws_security_group.allow_web.id]

  # associate_public_ip_address = true
    user_data = file("Deploy_commerce_app.sh")
  
  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling group 
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"
  min_size             = 2
  desired_capacity     = 3
  max_size             = 4
  
  health_check_type    = "ELB"
  load_balancers = [aws_elb.web_elb.id]
 
  launch_configuration = "${aws_launch_configuration.web.name}"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier  = [
  aws_subnet.Privet_subnet_1.id,
  aws_subnet.Privet_subnet_2.id,
  ]
  # Required to deploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
  }


output "LB_IP" {
  value = aws_elb.web_elb.dns_name
}