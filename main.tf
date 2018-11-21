locals {
  service_name            = "${local.unique_id}-odin"
  service_log_group_name  = "${local.unique_id}-odin-service-logs"
  service_container_port  = 8080
  region                  = "us-east-1"
}

module "service-infra" {
  source = "module"
  unique_id = "${local.unique_id}"
  region = "${local.region}"
  service_name = "${local.service_name}"
  target_group_name = "odin-tg"
  docker_image = "${var.docker_image}"
  cluster_name = "ecs-cluster"
  alb_path_pattern = "/odin/*"
  service_container_port = "${local.service_container_port}"
  vpc_name = "dev-ecs-workshop"
  service_log_group_name = "${local.service_log_group_name}"
  health_check_endpoint = "/odin/actuator/health"
  alb_name = "${local.unique_id}-asgard-alb"
}