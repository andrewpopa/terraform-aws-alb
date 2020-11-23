// vpc infrastructure
module "vpc" {
  source = "github.com/andrewpopa/terraform-aws-vpc"

  # VPC
  cidr_block          = "172.16.0.0/16"
  vpc_public_subnets  = ["172.16.10.0/24", "172.16.11.0/24", "172.16.12.0/24"]
  vpc_private_subnets = ["172.16.13.0/24", "172.16.14.0/24", "172.16.15.0/24"]
  availability_zones  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_tags = {
    vpc            = "my-aws-vpc"
    public_subnet  = "public-subnet"
    private_subnet = "private-subnet"
    internet_gw    = "my-internet-gateway"
    nat_gateway    = "nat-gateway"
  }
}

// security group
module "security-group" {
  source = "github.com/andrewpopa/terraform-aws-security-group"

  # Security group
  security_group_name        = "my-aws-security-group"
  security_group_description = "my-aws-security-group-descr"
  ingress_ports              = [22, 443, 8800, 5432]
  vpc_id                     = module.vpc.vpc_id
}

// ssh keys
module "key-pair" {
  source = "github.com/andrewpopa/terraform-aws-key-pair"
}

// ec2 instances
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
  key_name               = module.key-pair.public_key_name
  public_key             = module.key-pair.public_key
  public_ip              = true
  ec2_tags = {
    ec2 = "my-ptfe-instance"
  }
}

// letsencrypt certificates
module "acme" {
  source        = "github.com/andrewpopa/terraform-acme-letsencrypt"
  acme_provider = "https://acme-v02.api.letsencrypt.org/directory"
  email_address = "<EMAIL>"
  common_name   = "<DOMAIN>"
  dns_provider  = "cloudflare"
  dns_config = {
    CLOUDFLARE_EMAIL          = "<EMAIL>"
    CLOUDFLARE_API_KEY        = "<CLOUDFLARE_API>"
    CLOUDFLARE_ZONE_API_TOKEN = "<CLOUDFLARE_ZONE_TOKEN>"
  }
}

// application load balancer
module "alb" {
  source = "../"

  // Load balancer
  certificate_chain = module.acme.fullchain_pem
  certificate_body  = module.acme.certificate_pem
  private_key       = module.acme.private_key
  alb_name_prefix   = "ptfe-loadbalancer"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  target_id         = join("", module.ec2.id)
  vpc_id            = module.vpc.vpc_id
  tf_subnet         = module.vpc.public_subnets
  sg_id             = module.security-group.sg_id

  lbports = {
    8800 = "HTTPS",
    443  = "HTTPS",
  }
  alb_tags = {
    name = "alb-name"
  }
  cert_tags = {
    name = "letsencrypt-certificates"
  }
}