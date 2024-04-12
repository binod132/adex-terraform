variable "create_ECS" {
  description = "Determines if ECS needs to create."
  type        = bool
  default     = false
}

variable "create_ECR" {
  description = "Determines if ECR needs to create."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "subnet_a_id."
}

variable "subnet_a" {
  description = "subnet_a_id."
}

variable "subnet_b" {
  description = "subnet_b_id."
}

variable "ecs_name" {
  description = "Name of ECS Cluster"
}

variable "ecr_name" {
  description = "Name of ECR"
}
variable "task_definition_name" {
  description = "Name of task definition"
}
variable "alb_securitygroup_name" {
  description = "Name of task definition"
}

variable "alb_name" {
  description = "name of loadbalancer"
}

variable "target_group_name" {
  description = "name of target group"
}

variable "service_name" {
  description = "name of service"
}