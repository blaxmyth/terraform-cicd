resource "aws_ecs_cluster" "tradebot-ecs-cluster" {
  name = "tradebot-ecs-cluster"
}

resource "aws_ecs_service" "ecs-service" {
  name            = "tradebot-service"
  cluster         = aws_ecs_cluster.tradebot-ecs-cluster.id
  task_definition = aws_ecs_task_definition.tradebot-ecs-task-definition.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = [module.vpc.public_subnet1_id]
    assign_public_ip = true
    security_groups  = [module.vpc.security_group_ids]
  }
  load_balancer {
    # elb_name       = aws_elb.tradebot-elb.name
    container_name   = "tradebot"
    container_port   = 80
    target_group_arn = aws_lb_target_group.ecs_default_target_group.arn
  }
}

resource "aws_ecs_task_definition" "tradebot-ecs-task-definition" {
  family                   = "tradebot-ecs-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = aws_iam_role.task_definition_role.arn
  task_role_arn            = aws_iam_role.task_definition_role.arn
  container_definitions    = <<EOF
    [
        {
            "name": "tradebot",
            "image": "402008590331.dkr.ecr.us-east-1.amazonaws.com/tradebot:latest",
            "memory": 1024,
            "cpu": 512,
            "essential": true,
            "entryPoint": ["uvicorn", "app:app", "--host", "localhost", "--port", "80"],
            "portMappings": [
            {
                "containerPort": 80
            }
            ]
        }
    ]
EOF
}

resource "aws_alb" "ecs-alb" {
  name = "tradebot-alb"

  subnets                     = [module.vpc.public_subnet1_id,module.vpc.public_subnet2_id]
  idle_timeout                = 400
  security_groups             = [aws_security_group.tradebot-elb-sg.id]
  internal                    = false

  tags = {
    Name = "My Automated Load Balancer"
  }
}

resource "aws_lb_target_group" "ecs_default_target_group" {
  name     = "My-Automated-LB-Target-Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "60"
    timeout             = "30"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }

  tags = {
    Name = "My-Automated-Target-Group"
  }
}

resource "aws_alb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_alb.ecs-alb.arn
  port              = 80
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
#   certificate_arn   = aws_acm_certificate.ecs_domain_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_default_target_group.arn
  }

  depends_on = [aws_lb_target_group.ecs_default_target_group]
}

# resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
#   listener_arn = data.terraform_remote_state.platform.outputs.ecs_alb_listener_arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
#   }

#   condition {
#     host_header {
#       values = ["${lower(var.ecs_service_name)}.${data.terraform_remote_state.platform.outputs.ecs_domain_name}"]
#     }
#   }
# }