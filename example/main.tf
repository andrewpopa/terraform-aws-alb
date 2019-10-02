module "vpc" {
  source = "github.com/andrewpopa/terraform-aws-vpc"

  # VPC
  cidr_block          = "172.16.0.0/16"
  vpc_public_subnets  = ["172.16.10.0/24", "172.16.11.0/24", "172.16.12.0/24"]
  vpc_private_subnets = ["172.16.13.0/24", "172.16.14.0/24", "172.16.15.0/24"]
  vpc_tags = {
    vpc            = "my-aws-vpc"
    public_subnet  = "public-subnet"
    private_subnet = "private-subnet"
    internet_gw    = "my-internet-gateway"
    nat_gateway    = "nat-gateway"
  }
}

module "security-group" {
  source = "github.com/andrewpopa/terraform-aws-security-group"

  # Security group
  security_group_name        = "my-aws-security-group"
  security_group_description = "my-aws-security-group-descr"
  ingress_ports              = [22, 443, 8800, 5432]
  tf_vpc                     = module.vpc.vpc_id
}

module "ec2" {
  source   = "github.com/andrewpopa/terraform-aws-ec2"
  ami_type = "ami-0085d4f8878cddc81"
  ec2_instance = {
    type          = "m5.large"
    root_hdd_size = 50
    root_hdd_type = "gp2"
  }
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = module.security-group.sg_id
  key_name               = ""
  public_key             = ""
  public_ip              = true
  ec2_tags = {
    ec2 = "my-ptfe-instance"
  }
}

module "alb" {
  source = "../"

  # Load balancer
  name_cert       = "ptfe-lb-certs"
  cert_body       = "${file("files/cert1.pem")}"
  cert_chain      = "${file("files/chain1.pem")}"
  priv_key        = "${file("files/privkey1.pem")}"
  alb_name_prefix = "ptfe-loadbalancer"

  ssl_policy   = "ELBSecurityPolicy-2016-08"
  ec2_instance = module.ec2.ec2_ec2_id

  tf_vpc = module.vpc.vpc_id
  lbports = {
    8800 = "HTTPS",
    443  = "HTTPS",
  }

  tf_subnet = module.vpc.public_subnets
  sg_id     = module.security-group.sg_id

  alb_tags = {
    lb = "alb-name"
  }
}
