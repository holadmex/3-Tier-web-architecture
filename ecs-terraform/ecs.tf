## Create ECS Cluster
#resource "aws_ecs_cluster" "cluster" {
  #name = "web-app"
#}
#
## Create CloudWatch Log Group for ECS
#resource "aws_cloudwatch_log_group" "ecs_log_group" {
  #name              = "/ecs/frontend/"
  #retention_in_days = 7
#}
#
## ECS Task Definition
#resource "aws_ecs_task_definition" "task" {
  #family = "webapp-task"
  #container_definitions = jsonencode([
    #{
      #name      = "frontend"
      #image     = "nginx:latest"
      #cpu       = 1024
      #memory    = 3072
      #essential = true
#
      #portMappings = [
        #{
          #containerPort = 80
          #hostPort      = 80
          #protocol      = "tcp"
        #}
      #]
#
      #environment = [
        #/*{ name = "ENV_VAR_1", value = "value1" },
        #{ name = "ENV_VAR_2", value = "value2" } */
      #]
      #logConfiguration = {
        #logDriver = "awslogs"
        #options = {
          #"awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          #"awslogs-region"        = "us-east-1"
          #"awslogs-stream-prefix" = "ecs"
        #}
      #}
    #}
  #])
  #execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  #network_mode             = "awsvpc"
  #requires_compatibilities = ["FARGATE"]
  #cpu                      = "1024"
  #memory                   = "3072"
#}
#
#
## Security group for the load balancer
#resource "aws_security_group" "alb_sg" {
  #name        = "alb-sg"
  #description = "Allow HTTP/HTTPS traffic for the ALB"
  #vpc_id      = "vpc-29f0c052" # Replace with your VPC ID
#
  #ingress {
    #from_port   = 80
    #to_port     = 80
    #protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
  #}
#
  #ingress {
    #from_port   = 443
    #to_port     = 443
    #protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
  #}
#
  #egress {
    #from_port   = 0
    #to_port     = 0
    #protocol    = "-1"
    #cidr_blocks = ["0.0.0.0/0"]
  #}
#
  #tags = {
    #Name = "alb-sg"
  #}
#}
#
## Application Load Balancer
#resource "aws_lb" "alb" {
  #name               = "web-app-alb"
  #internal           = false
  #load_balancer_type = "application"
  #security_groups    = [aws_security_group.alb_sg.id]
  #subnets            = ["subnet-3a4cc635", "subnet-ba203d85"] # Replace with your Subnet IDs
#
  #enable_deletion_protection = false
#
  #tags = {
    #Name = "web-app-alb"
  #}
#}
#
## Target Group 
#resource "aws_lb_target_group" "tg" {
  #name        = "web-app-tg"
  #port        = 80
  #protocol    = "HTTP"
  #vpc_id      = "vpc-29f0c052" # Replace with your VPC ID
  #target_type = "ip"
#
  #health_check {
    #path                = "/"
    #interval            = 30
    #timeout             = 5
    #healthy_threshold   = 2
    #unhealthy_threshold = 2
    #matcher             = "200"
  #}
#
  #tags = {
    #Name = "web-app-tg"
  #}
#}
#
## Listener for HTTP traffic
#resource "aws_lb_listener" "http_listener" {
  #load_balancer_arn = aws_lb.alb.arn
  #port              = 80
  #protocol          = "HTTP"
#
  #default_action {
    #type             = "forward"
    #target_group_arn = aws_lb_target_group.tg.arn
  #}
#}
#
## ECS Service with Load Balancer Configuration
#resource "aws_ecs_service" "service" {
  #name            = "web-service"
  #cluster         = aws_ecs_cluster.cluster.arn
  #task_definition = aws_ecs_task_definition.task.arn
  #desired_count   = 0
  #launch_type     = "FARGATE"
#
  #network_configuration {
    #subnets          = ["subnet-3a4cc635", "subnet-ba203d85"] # Replace with your Subnet IDs
    #security_groups  = [aws_security_group.ecs_service_sg.id]
    #assign_public_ip = true
  #}
#
  #load_balancer {
    #target_group_arn = aws_lb_target_group.tg.arn
    #container_name   = "frontend" # Replace with your container name
    #container_port   = 80         # Replace with the port your app listens on
  #}
#
  #depends_on = [
    #aws_iam_policy_attachment.ecs_task_execution_attachment,
    #aws_lb_listener.http_listener
  #]
#}





data "aws_acm_certificate" "existing" {
  domain      = "*.holadmexbobpro.online" 
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "selected" {
  name         = "dev.holadmexbobpro.online" 
  private_zone = false
}

resource "aws_ecs_cluster" "cluster" {
  name = "web-app"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/frontend/"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "task" {
  family = "webapp-task"
  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "nginx:latest"
      cpu       = 1024
      memory    = 3072
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        /*{ name = "ENV_VAR_1", value = "value1" },
        { name = "ENV_VAR_2", value = "value2" } */
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS traffic for the ALB"
  vpc_id      = "vpc-29f0c052" 
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "alb-sg"
  }
}

resource "aws_lb" "alb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-3a4cc635", "subnet-ba203d85"] 
  enable_deletion_protection = false
  
  tags = {
    Name = "web-app-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "web-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-29f0c052" 
  target_type = "ip"
  
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
  
  tags = {
    Name = "web-app-tg"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.existing.arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.cluster.arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 0
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = ["subnet-3a4cc635", "subnet-ba203d85"] 
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "frontend" 
    container_port   = 80        
  }
  
  depends_on = [
    aws_iam_policy_attachment.ecs_task_execution_attachment,
    aws_lb_listener.http_listener,
    aws_lb_listener.https_listener
  ]
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "dev.holadmexbobpro.online" # Replace with your desired subdomain
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}