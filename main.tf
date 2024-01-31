
provider "aws" {
  region = "us-east-1"


}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
   tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
  
}

module "myapp-server" {
    source = "./modules/webserver"
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
    instance_type = var.instance_type
    my_ip = var.my_ip
    public_key_path = var.public_key_path
    subnet_id = module.myapp-subnet.subnet.id
    image_name = var.image_name 
    depends_on = [ module.myapp-subnet ]
}

resource "aws_route_table_association" "a-rtb-assoc" {
    subnet_id = module.myapp-subnet.subnet.id
    route_table_id = module.myapp-subnet.route_table.id
}

