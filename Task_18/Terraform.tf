#######################################################
# Launch Linux EC2 instances in two regions using a single Terraform file.
# This Terraform configuration launches a Linux EC2 instance in two different AWS regions (us-east-1 and us-east-2).
#######################################################

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

}
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}


resource "aws_instance" "Guvi_instance" {
  provider                    = aws.us-east-1
  ami                         = "ami-0731becbf832f281e"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = "subnet-021dfbb329fef1fb6"

  #key_name = "example_key_pair"

  tags = {
    Name = "Guvi_instance-us-east-1"
  }

}

resource "aws_instance" "Guvi_instance_2" {
  provider                    = aws.us-east-2
  ami                         = "ami-004364947f82c87a0"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = "subnet-03902be804a816843"

  #key_name = "example_key_pair"

  tags = {
    Name = "Guvi_instance_us-east-2"
  }

}