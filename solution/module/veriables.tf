variable "unique_id" {}
variable "docker_image" {}
variable "region" {}

# service veriables
variable "service_name" {}
variable "service_container_port" {}
variable "service_log_group_name" {}
variable "cluster_name" {}

# target group variables
variable "vpc_name" {}
variable "target_group_name" {}
variable "health_check_endpoint" {}
variable "alb_name" {}
variable "alb_path_pattern" {}