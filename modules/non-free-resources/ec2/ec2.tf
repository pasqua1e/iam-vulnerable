data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_security_group" "allow_ssh_from_world" {
  name        = "allow_ssh_from_world"
  description = "Allow SSH inbound traffic from world"

  ingress {
    description = "SSH from world"
    from_port   = 22
    to_port     = 22
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
    Name      = "allow_ssh_from_world"
    yor_trace = "f6b5df6c-a2ce-4cad-af3c-35a3f1f5e67b"
  }
}


resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon-2.id
  instance_type               = "t3.nano"
  iam_instance_profile        = "privesc-high-priv-service-profile"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_from_world.id]

  tags = {
    yor_trace = "7711cc76-8e00-4b50-9cce-0f6ca68fa4f1"
  }
}



