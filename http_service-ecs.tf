resource "aws_ecs_cluster" "http_serivce_cluster" {
  name = "http-serivce-cluster"
  tags = {
    name = "http-serivce-cluster"
  }
}

resource "aws_cloudwatch_log_group" "http_service_log_group" {
  name = "http-service-lg"

  tags = {
    Application = "http-service"
  }
}
resource "aws_ecs_task_definition" "http_service_TD" {
  family                   = "http-service"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.http_service_iam-role.arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "httpservice"
      image     = "hashicorp/http-echo"
      cpu       = 1024
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group  = aws_cloudwatch_log_group.http_service_log_group.name,
          awslogs-region = "af-south-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  tags = {
    name = "http-service-TD"
  }
}

resource "aws_security_group" "ecs-sg"{
  name = "ecs-sg"
  description = "allow HTTP access"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}