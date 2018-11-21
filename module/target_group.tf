data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

resource "aws_alb_target_group" "alb_odin_target_group" {
  name = "${var.unique_id}-${var.target_group_name}"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.aws_vpc.vpc.id}"

  deregistration_delay = 30

  tags {
    Name = "${var.unique_id}-${var.target_group_name}"
  }

  health_check {
    protocol            = "HTTP"
    path                = "${var.health_check_endpoint}"
    matcher             = "200"
    interval            = "10"
    timeout             = "5"
    healthy_threshold   = "3"
    unhealthy_threshold = "10"
  }
}

data "aws_alb" "alb" {
  name = "${var.alb_name}"
}

data "aws_alb_listener" "alb_ssh_listener" {
  load_balancer_arn = "${data.aws_alb.alb.arn}"
  port              = 443
}

resource "aws_alb_listener_rule" "alb_odin_listener_rule" {
  "action" {
    target_group_arn = "${aws_alb_target_group.alb_odin_target_group.arn}"
    type = "forward"
  }
  "condition" {
    field = "path-pattern"
    values = ["${var.alb_path_pattern}"]
  }
  listener_arn = "${data.aws_alb_listener.alb_ssh_listener.arn}"
}