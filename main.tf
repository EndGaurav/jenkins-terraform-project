resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Availability zone
data "aws_availability_zones" "available" {
  state = "available"
}


# subnet
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = var.subnet_tags
}

# Security group
resource "aws_security_group" "ssh_jenkins" {
  name        = "allow_tls"
  description = "Allow 8080 & 22 inbound traffic"
  vpc_id      = aws_default_vpc.default.id
  dynamic "ingress" {
    for_each = var.aws_sg
    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = var.Security_tags
}

# ec2 instance
resource "aws_instance" "jenkins_instance" {
    ami           = var.ami 
    instance_type = var.instance_type
    subnet_id = aws_default_subnet.default_az1.id
    vpc_security_group_ids = [aws_security_group.ssh_jenkins.id]
    key_name = var.key_name
    tags = var.tags
} 

# null resource
resource "null_resource" "name" {
  # ssh to ec2 instance
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/Downloads/ubuntu.pem")
    host = aws_instance.jenkins_instance.public_ip
  }

  # copy the shell script from local to the ec2 server
  provisioner "file" {
    source = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }

  # set permision and remote execution
  provisioner "remote-exec"{
    inline = [ 
      "sudo chmod +x /tmp/jenkins.sh",
      "sh /tmp/jenkins.sh"
     ]
  }

  depends_on = [ 
    aws_instance.jenkins_instance
   ]
}