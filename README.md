# terraform-aws-alb
Terraform module for application load-balancer on AWS

# Terraform version
This module was written and tested with Terraform v0.12.9 

# Assumptions
- You want to create security-group which will be attached to VPC and can be consumed by other resources inside VPC
- You have access to AWS console where you can create you security credentials `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- You configured your security credentials as your environment variables `~/.bash_profile` 

```
export AWS_ACCESS_KEY_ID=XXXX
export AWS_SECRET_ACCESS_KEY=XXXX
export AWS_DEFAULT_REGION=XXXX
```

# How to consume
- [`example`](https://github.com/andrewpopa/terraform-aws-alb/tree/master/example) folder contain an example of how to consume the module

as pre-requirement you'll need:
- github.com/andrewpopa/terraform-aws-vpc
- github.com/andrewpopa/terraform-aws-security-group
- github.com/andrewpopa/terraform-aws-ec2

```terraform
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

```

# Inputs
| **Name**  | **Type** | **Default** | **Required** | **Description** |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| name_cert | string | alb-certs | no | Certificates for load balancer |
| cert_body | string |  | yes | Certificate body |
| cert_chain | string |  | yes | Certificate chain |
| priv_key | string |  | no | Private key | 
| alb_name_prefix | string | default | yes | Load balancer prefix |
| ssl_policy | string | default | yes | SSL policy |
| ec2_instance | string | default | yes | EC2 instance behind load balancer |
| tf_vpc | string | default | yes | VPC where load balancer is running |
| lbports | string | default | yes | List of ports |
| tf_subnet | string | default | yes | list of VPC subnets |
| sg_id | string | default | yes | security group ID |
| alb_tags | string | default | yes | Tags |

# Outputs
| **Name**  | **Type** | **Description** |
| ------------- | ------------- | ------------- |
| alb_dns_name | string | AWS DNS records for ALB |