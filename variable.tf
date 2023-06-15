variable "region" {
  type = string
  default = "us-east-1"
}

variable "subnet_tags" {
  type = map(any)
  default = {
    Name = "Default subnet for us-east-1a"
  }
}

variable "aws_sg" {
  type = map(object({
    description = string
    port = number
    protocol = string
    cidr_blocks = list(string)
  }))

  default = {
    "22" = {
      description = "TLS from VPC"
      port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "8080" = {
      description = "TLS from VPC"
      port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "Security_tags" {
  type = map(any)
  default = {
    "Name" = "allow_ssh_jenkins"
  }
}

variable "ami" {
  type = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
  default = "ubuntu"
}

variable "tags" {
  type = map(any)
  default = {
    "Name" = "jenkins_server"
  }
}
