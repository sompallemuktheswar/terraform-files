data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}




resource "aws_security_group" "bastion" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description      = "ssh for admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}
resource "aws_security_group" "application-sg" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    description      = "ssh for admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups     = ["bastion.id"]
  }
 ingress {
    description      = "ssh for admin"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups     = ["bastion.id"]
 }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "application-sg"
  }
}
#  resource "aws_security_group" "alb-sg" {
#   name        = "allow_ssh"
#   description = "Allow ssh inbound traffic"
#   vpc_id      = "vpc-0b2294fc21a6a829d"


#   ingress {
#     description      = "ssh for admin"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     security_groups     = ["bastion.id"]
#   }
# ingress {
#     description      = "ssh for admin"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     security_groups     = ["bastion.id"]
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "alb-sg"
#   }
# }