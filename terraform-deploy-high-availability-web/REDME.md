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


![plot](https://github.com/udacity/nd9991-c2-Infrastructure-as-Code-v1/blob/master/supporting_material/AWSWebApp.jpeg)

- ##### Creating   VPC 
```diff 
resource "aws_vpc" "High_availability_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "name" = "High_availability_VPC"
  }
}
```
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