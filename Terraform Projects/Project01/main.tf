# Configure the AWS Provider
# provider "aws" {
#   version = "~> 4.0"
#   region  = "us-east-1"
# }


provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA5E5G2APXFOYAM6RK"
  secret_key = "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"
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