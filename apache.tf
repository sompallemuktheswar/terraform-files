# apache-security
resource "aws_security_group" "apache-sg" {
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
    Name = "apache-sg"

  }
}

resource "aws_instance" "apache-sg2" {
  ami                    ="ami-0eb375f24fdf647b8"
  instance_type          ="t2.micro"
  subnet_id              = "subnet-0a5a0278f9a145f1d"
  vpc_security_group_ids =[aws_security_group.apache-sg.id]
  key_name               = aws_key_pair.siva35.id
  user_data              = <<-EOF
 #!/bin/bash
 yum update -y 
 yum install httpd -y 
 systemctl start httpd
 systemctl enable httpd
  EOF


  tags = {
    Name = "apache-1"
  }
}
