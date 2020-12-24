resource "aws_eip" "eip_nlb" {
  tags    = {
    Name  = "hive-lb-eip"
  }
}
resource "aws_lb" "load_balancer" {
  name                              = "hive-network-lb"
  load_balancer_type                = "network"
  subnet_mapping {
    subnet_id     = aws_subnet.hive-private.id
    allocation_id = aws_eip.eip_nlb.id
  }
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn       = aws_lb.load_balancer.arn
  for_each = var.forwarding_config
      port                = each.key
      protocol            = each.value
      default_action {
        target_group_arn = aws_lb_target_group.tg[each.key].arn
        type             = "forward"
      }
}

resource "aws_lb_target_group_attachment" "tga1" {
  for_each = var.forwarding_config
    target_group_arn  = aws_lb_target_group.tg[each.key].arn
    port              = each.key
  target_id           = aws_instance.hive_private_1.id
}

resource "aws_lb_target_group_attachment" "tga2" {
  for_each = var.forwarding_config
    target_group_arn  = aws_lb_target_group.tg[each.key].arn
    port              = each.key
  target_id           = aws_instance.hive_private_2.id
}

resource "aws_lb_target_group" "tg" {
  for_each = var.forwarding_config
    port                  = each.key
    protocol              = each.value
	vpc_id                  = aws_default_vpc.default.id
	target_type             = "instance"
	deregistration_delay    = 90
	health_check {
		interval            = 30
		port                = each.value != "TCP_UDP" ? each.key : 80
		protocol            = "TCP"
		healthy_threshold   = 2
		unhealthy_threshold = 2
	  }
}