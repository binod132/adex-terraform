create_ECS = true
create_ECR = true
vpc_id     = "vpc-069bd2b64d5025272"
subnet_a   = "subnet-0208aa50d62d99317"
subnet_b   = "subnet-0fdc13e65cc171b40"

ecs_name = "ecs_dev2"
ecr_name = "ecr_dev2"
task_definition_name = "task_dev2"
alb_securitygroup_name = "alb_sg_dev2"
alb_name = "adex-dev2"
target_group_name = "adex-tg-dev2"
service_name = "service_dev2"