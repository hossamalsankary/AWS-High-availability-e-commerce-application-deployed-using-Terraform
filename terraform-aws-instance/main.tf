# Terraform  script for sample ec2  with security

# required providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"

    }
  }
}
provider "aws" {
  region =   "eu-central-1"

}
# Resources 

# Aws security group to allow http traffics 
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
 #  we not provide any vpc here so this security group  going be deploying on default VPC
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
    Name = "allow_web_in_default_vpc"
  }
}


# aws EC2 instance 
resource "aws_instance" "web-server-instance" {
 ami               = "ami-06dd92ecc74fdfb36"
  instance_type     = "t2.micro"
  key_name          = "terraform"
 vpc_security_group_ids = [ aws_security_group.allow_web.id]

ebs_block_device {
  device_name = "/dev/sda1"
   volume_type = "gp2"
   volume_size = 30
   delete_on_termination = true
  }
 #  we not provide any vpc here s this security group  going be deploying on default VPC

#  bash script for automating deploying process
  user_data =  "${file("Deploy_commerce_app.sh")}" 


  tags = {
    Name = "simple_web-server"
  }
}
output "server_ip" {
  value = aws_instance.web-server-instance.public_dns
}
