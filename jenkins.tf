resource "aws_security_group" "cicd"{
  name        = "cicd1"
  description = "Allow cicd inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "stage-cicd"
  }
}


# cicd:
resource "aws_instance" "jenkins" {
  ami                    = "ami-06489866022e12a14"
  instance_type          = "c5.xlarge"
  subnet_id              = aws_subnet.public-sub[0].id
  vpc_security_group_ids = [aws_security_group.cicd.id]
  key_name               = aws_key_pair.yawsanth.id
  user_data              = <<-EOF
 #!/bin/bash
 yum update -y
 sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
 sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
 yum install epel-release # repository that provides 'daemonize'
 amazon-linux-extras install epel
 amazon-linux-extras install java-openjdk11 -y
#  yum install java-11-openjdk-devel
 yum install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins
  EOF



  tags = {
    Name = "stage-cicd"
  }
}
