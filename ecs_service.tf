locals {
  service_name            = "${local.unique_id}-odin"
  service_log_group_name  = "${local.unique_id}-odin-service-logs"
  service_container_port  = 8080
  region                  = "us-east-1"
}

data aws_ecs_cluster "asgard_cluster" {
  cluster_name = "${local.unique_id}-ecs-cluster"
}

resource "aws_ecs_service" "service" {
  name                               = "${local.service_name}"
  cluster                            = "${data.aws_ecs_cluster.asgard_cluster.cluster_name}"
  task_definition                    = "${aws_ecs_task_definition.task_definition.arn}"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  health_check_grace_period_seconds  = 60

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_odin_target_group.arn}"
    container_name   = "${local.service_name}"
    container_port   = "${local.service_container_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "${local.service_log_group_name}"
  retention_in_days = 7
}