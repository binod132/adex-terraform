provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "my_cluster" {
  #name = "my-ecs-cluster"
  
  name = var.ecs_name
}

resource "aws_ecr_repository" "my_ecr_repository" {
  #name = "my-ecr-repo"
  name = var.ecr_name
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.my_ecr_repository.name
  policy     = local.ecr_policy
}

#This is the policy defining the rules for images in the repo
locals {
  ecr_policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire images older than 14 days",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 14
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}

#The commands below are used to build and push a docker image of the application in the app folder
locals {
  docker_login_command = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 232048837608.dkr.ecr.us-east-1.amazonaws.com"
  docker_build_command = "docker build -t my-ecr-repo -f Dockerfile ."
  docker_tag_command   = "docker tag my-ecr-repo:latest 232048837608.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest"
  docker_push_command  = "docker push 232048837608.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest"
}

#This resource authenticates you to the ECR service
resource "null_resource" "docker_login" {
  provisioner "local-exec" {
    command = local.docker_login_command
  }
  triggers = {
    "run_at" = timestamp()
  }
  depends_on = [aws_ecr_repository.my_ecr_repository]
}

#This resource builds the docker image from the Dockerfile in the app folder
resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = "cd .. && cd application && ${local.docker_build_command}"
  }
  triggers = {
    "run_at" = timestamp()
  }
  depends_on = [null_resource.docker_login]
}

#This resource tags the image 
resource "null_resource" "docker_tag" {
  provisioner "local-exec" {
    command = local.docker_tag_command
  }
  triggers = {
    "run_at" = timestamp()
  }
  depends_on = [null_resource.docker_build]
}

#This resource pushes the docker image to the ECR repo
resource "null_resource" "docker_push" {
  provisioner "local-exec" {
    command = local.docker_push_command
  }
  triggers = {
    "run_at" = timestamp()
  }
  depends_on = [null_resource.docker_tag]
}
# ECS Infra
resource "aws_ecs_task_definition" "my_task_definition" {
  family             = "my-task-def"
  task_role_arn      = "arn:aws:iam::232048837608:role/ECS_TASK"
  execution_role_arn = "arn:aws:iam::232048837608:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([{
    name      = "my-container"
    image     = "${aws_ecr_repository.my_ecr_repository.repository_url}:latest"
    cpu       = 0
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
      protocol      = "tcp"
      appProtocol   = "http"
    }]
  }])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

}

data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "alb_security_group" {
  #name = "alb-sg"
  name   = var.alb_securitygroup_name
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_lb" "alb" {
  #name               = "my-alb"
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_security_group.id
  ]

  subnets = [var.subnet_a, var.subnet_b]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "target_group" {
  #name     = "my-tg"
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
  health_check {
    interval            = 90
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 2
    path                = "/"
    matcher             = "200-299"
  }
}

resource "aws_ecs_service" "service" {
  #name                               = "service-terra"
  name            = var.service_name
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  #deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
  #deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "my-container"
    container_port   = 3000
  }

  network_configuration {
    #security_groups  = [aws_security_group.ecs_container_instance.id]
    security_groups = [
      aws_security_group.alb_security_group.id
    ]
    subnets          = [var.subnet_a, var.subnet_b]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
#resource "aws_lb_target_group_attachment" "target_group_attachment" {
#  target_group_arn = aws_lb_target_group.target_group.arn
#  target_id        = aws_ecs_task_definition.my_task_definition.arn
#  port             = 3000
#}