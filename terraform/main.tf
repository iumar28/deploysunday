provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ec2_security_group" {
  name_prefix = "ec2-security-group-"
  description = "Allow inbound traffic for EC2 instance"
  
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

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "my-ec2-key"
  public_key = var.ec2_public_key
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ec2_key_pair.key_name
  security_groups = [
    aws_security_group.ec2_security_group.name
  ]
  tags = {
    Name = "AcmfEC2Instance"
  }
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

