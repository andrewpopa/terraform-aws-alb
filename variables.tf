# LB

variable "alb_tags" {
  type = map
  default = {
    lb = "alb-name"
  }
}

variable "name_cert" {
  type        = string
  default     = "alb-certs"
  description = "Certificates for load balancer"
}

variable "cert_body" {
  type        = string
  default     = ""
  description = "Certificate body"
}

variable "cert_chain" {
  type        = string
  default     = ""
  description = "Certificate chain"
}

variable "priv_key" {
  type        = string
  default     = ""
  description = "Private key"
}

variable "alb_name_prefix" {
  type        = string
  default     = ""
  description = "Load balancer name prefix"
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "Security policy"
}

variable "ec2_instance" {
  type        = string
  default     = ""
  description = "EC2 instance for load balancing"
}

variable "alb_target_group_name" {
  type        = string
  default     = ""
  description = "ALB target group name"
}

variable "tf_vpc" {
  type        = string
  default     = ""
  description = "VPC ID"
}

variable "tf_subnet" {
  type        = list
  description = "VPC list of subnets"
}

variable "sg_id" {
  type        = string
  default     = ""
  description = "Security Group ID"
}

variable "lbports" {
  default = {
    443  = "HTTPS",
  }
  description = "Default ALB listener port and protocol"
}