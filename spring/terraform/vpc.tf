resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"

  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = false
  }
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = false
  }

}

// define public and private subnets
resource "aws_subnet" public_subnet {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = "172.31.16.0/20"
  map_public_ip_on_launch   = true
}