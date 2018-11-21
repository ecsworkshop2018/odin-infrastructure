[
  {
    "name": "${service_name}",
    "image": "${docker_image}",
    "memory": 256,
    "cpu": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${service_name}"
      }
    }
  }
]
