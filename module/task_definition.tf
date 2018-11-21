
resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.service_name}"
  container_definitions = "${data.template_file.container_definitions_json.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "container_definitions_json" {
  template = "${file("${path.module}/container-definitions.json.tpl")}"

  vars {
    service_name       = "${var.service_name}"
    docker_image       = "${var.docker_image}"
    container_port     = "${var.service_container_port}"
    log_group          = "${var.service_log_group_name}"
    region             = "${var.region}"
  }
}