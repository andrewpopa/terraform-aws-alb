# Load balancing

resource "aws_iam_server_certificate" "tf_cert" {
  name_prefix       = var.name_cert
  certificate_body  = var.cert_body
  certificate_chain = var.cert_chain
  private_key       = var.priv_key

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "tf_alb" {
  name            = var.alb_name_prefix
  subnets         = var.tf_subnet
  security_groups = [var.sg_id]
  internal        = false
  tags = {
    Name = var.alb_tags["lb"]
  }
}

# Frontend
resource "aws_lb_listener" "tf_frontend" {
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = local.keys[count.index]
  protocol          = local.values[count.index]
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_iam_server_certificate.tf_cert.arn
  count             = local.num

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_target_frontend[count.index].arn
  }
}

resource "aws_lb_target_group" "tf_target_frontend" {
  name        = "${local.keys[count.index]}-on-${local.values[count.index]}"
  port        = local.keys[count.index]
  protocol    = local.values[count.index]
  target_type = "instance"
  vpc_id      = var.tf_vpc
  count       = local.num
}

resource "aws_lb_target_group_attachment" "tf_attach_frontend" {
  count            = local.num
  target_group_arn = aws_lb_target_group.tf_target_frontend[count.index].arn
  target_id        = var.target_id
  port             = local.keys[count.index]
}