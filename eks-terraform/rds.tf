

# Database Subnet Group using existing private subnets
resource "aws_db_subnet_group" "main" {
  name       = "${var.cluster_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.cluster_name}-db-subnet-group"
  }
}

# Database Security Group
resource "aws_security_group" "rds" {
  name_prefix = "${var.cluster_name}-rds-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-rds-sg"
  }
}

# RDS PostgreSQL Instance (Free Tier)
resource "aws_db_instance" "postgres" {
  identifier = "${var.cluster_name}-postgres"

  engine         = "postgres"
  engine_version = "16.4"
  instance_class = "db.t3.micro"  # Free tier eligible

  allocated_storage = 20  # Free tier: up to 20GB
  storage_type      = "gp2"
  storage_encrypted = false  # Encryption not available in free tier

  db_name  = "webapp"
  username = "postgres"
  password = random_password.db_password.result

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 0  # No backups for free tier
  skip_final_snapshot     = true
  deletion_protection     = false

  # Disable paid features for free tier
  performance_insights_enabled = false
  monitoring_interval          = 0

  tags = {
    Name = "${var.cluster_name}-postgres"
  }
}

# Random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}