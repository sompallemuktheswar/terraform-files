resource "aws_security_group" "cicd2"{
  name        = "cicd1"
  description = "Allow cicd inbound traffic"
  vpc_id      = "vpc-023bf781f4ec85820"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }


  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
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
    Name = "stage-cicd1"
  }
}


# cicd:
resource "aws_instance" "jenkins1" {
  ami                    = "ami-0eb375f24fdf647b8"
  instance_type          = "c5.xlarge"
  subnet_id              = "subnet-0947c5877bd437a90"
  vpc_security_group_ids = [aws_security_group.cicd2.id]
  key_name               = aws_key_pair.siva35.id
  user_data              = <<-EOF
 #!/bin/bash
 yum update -y
 sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
 sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
 yum install epel-release # repository that provides 'daemonize'
 amazon-linux-extras install epel -y
 amazon-linux-extras install java-openjdk11 -y
#  yum install java-11-openjdk-devel
 yum install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins
  EOF



  tags = {
    Name = "stage-cicd1"
  }
}
