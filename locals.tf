locals {
  keys   = keys(var.lbports)
  values = values(var.lbports)
  num    = length(var.lbports)
}