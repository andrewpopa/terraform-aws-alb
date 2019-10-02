variable "tf_subnet" {
  description = "VPC subnets"
  type        = list
  default     = []
}
variable "lbports" {
  description = "Default ALB listener port and protocol"
  type        = map
  default     = {}
}