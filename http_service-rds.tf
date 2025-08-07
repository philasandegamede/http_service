resource "aws_db_instance" "postgres-db" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"
  db_name              = "http-service-db"
  username             = "admin"
  password             = "1qazxsw2"
  parameter_group_name = "default.posgres15"
  skip_final_snapshot  = true

  vpc_security_group_ids = [ aws_security_group.db_sg.id ]
  db_subnet_group_name = aws_security_group.db_sg.name
  multi_az = false
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "db_sg"
  }
}

resource "aws_security_group" "postgress-sg"{
    name = "postgres-ecs-sg"
    vpc_id = module.vpc.vpc_id
    description = "Allow traffic from ecs to postgres db"

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [ aws_security_group.ecs-sg.id]
    }
}
