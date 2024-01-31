

variable "vpc_cidr_block" {
  type = string
  description = "value of cidr block"
}

variable "subnet_cidr_block" {
  type = string
  description = "value of cidr block"
  default = "10.0.10.0/24"
}

variable "avail_zone" {
  type = string
  description = "value of availability zone"
  default = "us-east-1a"
}

variable "env_prefix" {
  type = string

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

variable "vpc_id" {
  type = string
  description = "value of vpc id"
  
}

variable "public_key_path" {
  type = string
  description = "value of public key path"
  default = "/Users/ilemo/.ssh/id_rsa.pub"
  
}

variable "image_name" {
  type = string
  description = "value of image name"
  default = "amzn2-ami-hvm-2.0.20210622.0-x86_64-gp2"
  
}


