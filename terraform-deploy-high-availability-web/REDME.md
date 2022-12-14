**
# **Deploy** Infrastructure as Code using Terraform  
####  Deploy Infrastructure as Code we will deploy a dummy  web store application (This is a sample e-commerce application built for learning purposes.) to the Apache Web Server running on an EC2 instance. [e-commerce application ](https://github.com/kodekloudhub/learning-app-ecommerce)
 <img src="https://github.com/udacity/nd9991-c2-Infrastructure-as-Code-v1/blob/master/supporting_material/AWSWebApp.jpeg" alt="Permissions" align="right" />
 
## Content 
- ##### [Creating   VPC ](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#creating---vpc)
- ##### [Crate internet getaway](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#crate-internet-getaway-1)
- ##### [Create public  subnets (1)](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-public--subnets-1-1)
- ##### [Create public  subnets (2)](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-public--subnets-1-1)
- ##### [Create Privet  subnets (1)](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-privet--subnets-1-1)
- ##### [Create Privet  subnets (2)](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-privet--subnets-1-1)
- ##### [Create Nate gateway with Elastic_ip For Public subnet (1)](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-nate-gateway-with-elastic_ip-for-public-subnet-1-1)
- ##### [Create Nate gateway with Elastic_ip For Public subnet (2)](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-nate-gateway-with-elastic_ip-for-public-subnet-2-1)
- ##### [Create Route Table resource with routes defined in-line for public subnets](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-route-table-resource-with-routes-defined-in-line-for-public-subnets-1)
- ##### [Create Route Table resource with routes defined in-line for privet subnets](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-route-table-resource-with-routes-defined-in-line-for-privet-subnets-1)
- ##### [Creating Security Group for ELB](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#creating-security-group-for-web-server)
- ##### [ Create load balancer ](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#create-load-balancer)
- #####  [launch configuration](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#launch-configuration-1)
- ##### [ Autoscaling group ](https://github.com/hossamalsankary/terraform-projects/blob/master/terraform-deploy-high-availability-web/REDME.md#autoscaling-group)







## Creating   VPC 
```diff 
resource "aws_vpc" "High_availability_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "name" = "High_availability_VPC"
  }
}


```
 <img src="/images/1.png" alt="Permissions" width="600"  />

## Crate internet getaway

```diff 

resource "aws_internet_gateway" "High_availability_gw" {
  vpc_id = aws_vpc.High_availability_vpc.id
  tags = {
    "name" = "High_availability_gw"
  }
}

```
 <img src="/images/2.png"  width="600"  />


## Create public  subnets (1)
```diff 

resource "aws_subnet" "Public_subnet_1" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.public_subnets_cidr_blocks[0]
  availability_zone = var.east_Availability_Zones[0]
  tags = {
    "name" = "Public subnet_1"
  }

}

```
 ## Create public  subnets (2)
```diff 

resource "aws_subnet" "Public_subnet_2" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.public_subnets_cidr_blocks[1]
  availability_zone = var.east_Availability_Zones[1]
  tags = {
    "name" = "Public subnet_2"
  }
}

```
## Create Privet  subnets (1)
```diff 
resource "aws_subnet" "Privet_subnet_1" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.Privet_subnets_cidr_blocks[0]
  availability_zone = var.east_Availability_Zones[0]
  tags = {
    "name" = "Privet_subnet_1 "
  }

}

```
 ## Create Privet  subnets (2)
```diff 
resource "aws_subnet" "Privet_subnet_2" {
  vpc_id            = aws_vpc.High_availability_vpc.id
  cidr_block        = var.Privet_subnets_cidr_blocks[1]
  availability_zone = var.east_Availability_Zones[1]
  tags = {
    "name" = "Privet_subnet_2"
  }
}

```
 <img src="/images/3.png"  width="600"  />

 ## Create Nate gateway with Elastic_ip For Public subnet (1)
```diff 
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


```
 ## Create Nate gateway with Elastic_ip For Public subnet (2)
``` diff 

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

```
 <img src="/images/4.png"  width="600"  />

 ## Create Route Table resource with routes defined in-line for public subnets

```diff 
- ###### Route Table for  public subnet (1)
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

- ###### Route Table for  public subnet (2)

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

```
 ## Create Route Table resource with routes defined in-line for privet subnets
```diff
- ###### Route Table for  privet subnet (1)

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

- ###### Route Table for  privet subnet (2)

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

 ```

  <img src="/images/6.png"  width="600"  />


## Creating Security Group for Web server
```diff 
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

```
## Creating Security Group for LB
```diff 
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
```
##  Create load balancer 
```diff 
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
```
##  launch configuration
```diff 
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

```

##  Autoscaling group 
```diff 

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

```
  <img src="/images/7.png"  width="600"  />

  ###  Real live **picturers** 
  <img src="/images/10.png"  />
  <img src="/images/11.png"  />
  <img src="/images/12.png"  />
  <img src="/images/13.png"  />
  <img src="/images/14.png"  />
  <img src="/images/15.png"  />
  <img src="/images/16.png"  />



**






