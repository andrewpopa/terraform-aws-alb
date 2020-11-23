# LB

variable "alb_tags" {
  type = map
  default = {
    name = "alb-name"
  }
}

variable "certificate_body" {
  type        = string
  description = "certificate body"
}

variable "certificate_chain" {
  type        = string
  description = "certificate chain"
}

variable "private_key" {
  type        = string
  description = "private key"
}

variable "cert_tags" {
  type        = map(string)
  description = "tags for certificate import"
  default = {
    name = "imported-certificate"
  }
}

variable "alb_name_prefix" {
  type        = string
  description = "Load balancer name prefix"
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
  description = "Security policy"
}

variable "target_id" {
  type        = string
  description = "EC2 instance for load balancing"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "tf_subnet" {
  type        = list
  description = "VPC list of subnets"
}

variable "sg_id" {
  type        = string
  description = "Security Group ID"
}

variable "lbports" {
  type        = map(string)
  description = "application loadbalancer ports map"
  default = {
    443 = "HTTPS"
  }
}