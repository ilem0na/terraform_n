variable "avail_zone" {
  type = string
  description = "value of availability zone"
  default = "us-east-1a"
}

variable "env_prefix" {
  type = string

}

variable "vpc_id" {
  type = string
  description = "value of vpc id"
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

variable "image_name" {
  type = string
  description = "value of image name"
  default = "amzn2-ami-hvm-2.0.20210622.0-x86_64-gp2"
  
}

variable "subnet_id" {
  type = string
  description = "value of subnet id"
  
}
