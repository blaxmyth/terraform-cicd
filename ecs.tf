# resource "aws_ecs_cluster" "tradebot-ecs-cluster" {
#   name = "tradebot-ecs-cluster"
# }

# resource "aws_ecs_service" "tradebot-ecs-service" {
#   name            = "tradebot-service"
#   cluster         = aws_ecs_cluster.tradebot-ecs-cluster.id
#   task_definition = aws_ecs_task_definition.tradebot-ecs-task-definition.arn
#   launch_type     = "FARGATE"
#   network_configuration {
#     subnets          = [module.vpc.subnet_id]
#     assign_public_ip = true
#   }
#   desired_count = 1
#   #   load_balancer {
#   #     elb_name       = aws_elb.tradebot-elb.name
#   #     container_name = "tradebot"
#   #     container_port = 80
#   #   }
# }

# resource "aws_ecs_task_definition" "tradebot-ecs-task-definition" {
#   family                   = "tradebot-ecs-task-definition"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   memory                   = "1024"
#   cpu                      = "512"
#   execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
#   container_definitions    = <<EOF
#     [
#         {
#             "name": "tradebot",
#             "image": "402008590331.dkr.ecr.us-east-1.amazonaws.com/tradebot:latest",
#             "memory": 1024,
#             "cpu": 512,
#             "essential": true,
#             "entryPoint": ["/"],
#             "portMappings": [
#             {
#                 "containerPort": 80
#             }
#             ]
#         }
#     ]
# EOF
# }

# resource "aws_elb" "tradebot-elb" {
#   name = "tradebot-elb"
#   #   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

#   #   access_logs {
#   #     bucket        = "foo"
#   #     bucket_prefix = "bar"
#   #     interval      = 60
#   #   }

#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }

#   #   listener {
#   #     instance_port      = 80
#   #     instance_protocol  = "http"
#   #     lb_port            = 443
#   #     lb_protocol        = "https"
#   #     ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
#   #   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 60
#   }

#   subnets                     = [module.vpc.subnet_id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "tradebot-elb"
#   }
# }