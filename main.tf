
provider "aws" {
  region = "us-east-1"
}

variable "subnet_cidr_block" {
  type = string
  description = "value of cidr block"
  default = "10.0.10.0/24"
}

variable "vpc_cidr_block" {
  type = string
  description = "value of cidr block"
}

variable "avail_zone" {
  type = string
  description = "value of availability zone"
  default = "us-east-1a"
}

variable "env_prefix" {
  type = string

}

variable "private_key_path" {
  type = string
  description = "value of private key path"
  default = "/Users/ilemo/.ssh/id_rsa"

}

variable "instance_type" {
  type = string
  description = "value of instance type"
  default = "t2.micro"
  
}

variable "my_ip" {
  type = string
  description = "value of my ip"
  
}

variable "public_key_path" {
  type = string
  description = "value of public key path"
  default = "/Users/ilemo/.ssh/id_rsa.pub"
  
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
   tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-route-table"
    }
  
}

resource "aws_route_table_association" "a-rtb-assoc" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
    name = "myapp-${var.env_prefix}-sg"
    description = "Allow http and ssh"
    vpc_id = aws_vpc.myapp-vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" // any protocol
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = [] // any prefix list for outbound traffic
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
  
}

resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    public_key = file(var.public_key_path)
  
}

resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone
    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

    // user_data = file("entry-script.sh")
    tags = {
        Name: "${var.env_prefix}-server"
    }
    // defines the connection to the EC2 instance and we have only two ways to connect to the instance which are ssh and winrm. SSH is the daemon program for ssh connections to the EC2 instance and winrm is the daemon program for Windows Remote Management connections to the EC2 instance.
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file(var.private_key_path)
    }
    //  copy files from our local machine to the EC2 instance
    provisioner "file" {
      source = "entry-script.sh"
      destination = "/home/ec2-user/entry-script.sh"
      
    }

    provisioner "local-exec" {
        command = "echo ${self.public_ip} > public_ip.txt"
      }

    provisioner "remote-exec" {
      script = file("entry-script.sh")
      
    }
}

output "aws_public_IP" {
    value = aws_instance.myapp-server.public_ip
  
}

