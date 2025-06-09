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

resource "aws_key_pair" "us-east-1-key" {
  provider   = aws.us-east-1
  key_name   = "us-east-1-key"
  public_key = file("~/.ssh/id_rsa.pub")

}
resource "aws_key_pair" "us-east-2-key" {
  provider   = aws.us-east-2
  key_name   = "us-east-2-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_security_group" "us-east-1-sg" {
  provider    = aws.us-east-1
  name        = "us-east-1-sg"
  description = "Security group for us-east-1 instances"
  vpc_id      = "vpc-01f549d763593b23e"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "us-east-2-sg" {
  provider    = aws.us-east-2
  name        = "us-east-2-sg"
  description = "Security group for us-east-2 instances"
  vpc_id      = "vpc-09dd6e4aac2292d8f"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Note: Replace the VPC IDs and CIDR blocks with your actual values.
resource "aws_instance" "Guvi_instance" {
  provider                    = aws.us-east-1
  ami                         = "ami-0731becbf832f281e"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = "subnet-021dfbb329fef1fb6"
  security_groups             = [aws_security_group.us-east-1-sg.id]
  key_name                    = aws_key_pair.us-east-1-key.key_name
  #key_name = "example_key_pair"

  tags = {
    Name = "Guvi_instance-us-east-1"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }

  }

}

resource "aws_instance" "Guvi_instance_2" {
  provider                    = aws.us-east-2
  ami                         = "ami-004364947f82c87a0"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = "subnet-03902be804a816843"
  security_groups             = [aws_security_group.us-east-2-sg.id]
  key_name                    = aws_key_pair.us-east-2-key.key_name

  #key_name = "example_key_pair"

  tags = {
    Name = "Guvi_instance_us-east-2"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }

  }

}