data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["dev-ecs-workshop"]
  }
}

resource "aws_alb_target_group" "alb_odin_target_group" {
  name = "${local.unique_id}-odin-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.aws_vpc.vpc.id}"

  deregistration_delay = 30

  tags {
    Name = "${local.unique_id}-odin-tg"
  }

  health_check {
    protocol            = "HTTP"
    path                = "/odin/actuator/health"
    matcher             = "200"
    interval            = "10"
    timeout             = "5"
    healthy_threshold   = "3"
    unhealthy_threshold = "10"
  }
}

data "aws_alb" "alb" {
  name = "${local.unique_id}-asgard-alb"
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
    values = ["/odin/*"]
  }
  listener_arn = "${data.aws_alb_listener.alb_ssh_listener.arn}"
}

