variable "vpc_cidr_block" {
  type = string
  description = "value of cidr block"
  default = "10.0.0.0/16" 
}

variable "azs" {
  type = list(string)
  description = "value of availability zone"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets_cidr_block" {
  type = list(string)
  description = "value of private subnet cidr block"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 
}

variable "public_subnets_cidr_block" {
    type = list(string)
    description = "value of public subnet cidr block"
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] 
}

variable "vpc_name" {
  type = string
  description = "value of vpc name"
  default = "myapp-vpc"
  
}

variable "env_prefix" {
  type = string
  description = "value of environment prefix"
  default = "dev" 
}


variable "cluster_name" {
  type = string
  description = "value of cluster name"
  default = "myapp-eks-cluster"
  
}