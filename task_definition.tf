resource "aws_ecs_task_definition" "task_definition" {
  family                = "${local.service_name}"
  container_definitions = "${data.template_file.container_definitions_json.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "container_definitions_json" {
  template = "${file("./container-definitions.json.tpl")}"

  vars {
    service_name       = "${local.service_name}"
    docker_image       = "${var.docker_image}"
    container_port     = "${local.service_container_port}"
    log_group          = "${local.service_log_group_name}"
    region             = "${local.region}"
  }
}