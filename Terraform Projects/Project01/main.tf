# Configure the AWS Provider
# provider "aws" {
#   version = "~> 4.0"
#   region  = "us-east-1"
# }


provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

# ****To Create an Instance****
# resource "aws_instance" "myServer" {
#   ami           = "ami-0dfcb1ef8550277af"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "HelloWorld"
#   }
# }

# ****To Create VPC****
resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC_Sheham"
  }
}

# Subnet 
resource "aws_subnet" "subnet-1" {      # Referencing above vpc 
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Sheham_Subnet"
  }
}
