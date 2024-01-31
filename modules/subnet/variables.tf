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

variable "vpc_id" {
  type = string
  description = "value of vpc id"
}