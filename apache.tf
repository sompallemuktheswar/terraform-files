# apache-security
resource "aws_security_group" "apache-sg1" {
  name        = "apache-sg"
  description = "Allow inbound traffic"
  vpc_id      = "vpc-023bf781f4ec85820"

  ingress {
    description = "from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "from admin"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache-sg1"

  }
}

resource "aws_instance" "apache" {
  ami                    ="ami-0eb375f24fdf647b8"
  instance_type          ="t2.micro"
  subnet_id              = "subnet-0947c5877bd437a90"
  vpc_security_group_ids =[aws_security_group.apache-sg1.id]
  key_name               = aws_key_pair.siva35.id
  user_data              = <<-EOF
 #!/bin/bash
 yum update -y 
 yum install httpd -y 
 systemctl start httpd
 systemctl enable httpd
  EOF


  tags = {
    Name = "apache"
  }
}
