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
  port              = local.http_tcp_listeners[count.index]["port"]
  protocol          = local.http_tcp_listeners[count.index]["protocol"]
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_iam_server_certificate.tf_cert.arn
  count             = local.http_tcp_listeners_count

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_target_frontend[lookup(local.http_tcp_listeners[count.index], "target_group_index", 0)].id
  }
}

resource "aws_lb_target_group" "tf_target_frontend" {
  port        = local.http_tcp_listeners[count.index]["port"]
  protocol    = local.http_tcp_listeners[count.index]["protocol"]
  target_type = "instance"
  vpc_id      = var.tf_vpc
  count       = local.http_tcp_listeners_count
}

resource "aws_lb_target_group_attachment" "tf_attach_frontend" {
  count            = local.http_tcp_listeners_count
  target_group_arn = aws_lb_target_group.tf_target_frontend[lookup(local.http_tcp_listeners[count.index], "target_group_index", 0)].id
  target_id        = var.ec2_instance
  port             = local.http_tcp_listeners[count.index]["port"]
}