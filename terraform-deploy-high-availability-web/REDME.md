
# Content 
- ##### Creating   VPC 
- ##### Crate internet getaway
- ##### Create public  subnets (1)
- ##### Create public  subnets (2)
- ##### Create Privet  subnets (1)
- ##### Create Privet  subnets (2)
- ##### Create Nate gateway with Elastic_ip For Public subnet (1)
- ##### Create Nate gateway with Elastic_ip For Public subnet (2)
- ##### Create Route Table resource with routes defined in-line for public subnets
- ##### Create Route Table resource with routes defined in-line for privet subnets
- ##### Creating Security Group for ELB
- #####  Create load balancer 
- #####  Autoscaling group 
- #####  Autoscaling group 


 <img src="https://github.com/udacity/nd9991-c2-Infrastructure-as-Code-v1/blob/master/supporting_material/AWSWebApp.jpeg" alt="Permissions" align="right" />



- ##### Creating   VPC 
```diff 
resource "aws_vpc" "High_availability_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "name" = "High_availability_VPC"
  }
}


```
 <img src="/images/1.png" alt="Permissions" width="400"  />

- ##### Crate internet getaway

```diff 

resource "aws_internet_gateway" "High_availability_gw" {
  vpc_id = aws_vpc.High_availability_vpc.id
  tags = {
    "name" = "High_availability_gw"
  }
}

```
 <img src="/images/2.png"  width="400"  />


- ##### Create public  subnets (1)
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
- ##### Create public  subnets (2)
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
- ##### Create Privet  subnets (1)
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
- ##### Create Privet  subnets (2)
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
 <img src="/images/3.png"  width="400"  />

- ##### Create Nate gateway with Elastic_ip For Public subnet (1)
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
- ##### Create Nate gateway with Elastic_ip For Public subnet (2)
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
 <img src="/images/4.png"  width="400"  />

- ##### Create Route Table resource with routes defined in-line for public subnets

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
- ##### Create Route Table resource with routes defined in-line for privet subnets
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

 ```

  <img src="/images/5.png"  width="400"  />


- ##### Creating Security Group for ELB
- #####  Create load balancer 
- #####  Autoscaling group 
- #####  Autoscaling group 