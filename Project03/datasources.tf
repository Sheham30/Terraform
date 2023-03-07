# The AMI Datasource
# Datasource is basically a query of the AWS API to receive information needed to deploy a resource
data "aws_ami" "sh_ami" {
#   executable_users = ["self"]
  most_recent      = true
#   name_regex       = "^myami-\\d{3}"
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}