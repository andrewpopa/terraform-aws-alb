variable "lbports" {
  type        = map(string)
  description = "application loadbalancer ports map"
  default = {
    443 = "HTTPS"
  }
}