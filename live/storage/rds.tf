provider "aws" {
  region  = local.provider.region
  profile = local.provider.profile
}

locals {
  provider = {
    region  = "ap-northeast-2"
    profile = "terraform"
  }
}


# terraform {
#   backend "s3" {
#     bucket  = "terraform-state"
#     key     = "storage/terraform.tfstate"
#     region  = "ap-northeast-2"
#     encrypt = true
# dynamodb_table = "terraform-lock"
#   }
# }

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "db-instance-terraform"

  engine            = "mysql"
  engine_version    = "8.0.21"
  instance_class    = "db.m5.large"
  allocated_storage = 100

  name     = "demodb"
  username = "root"
  password = "testtest"
  port     = "3306"

  multi_az            = false
  publicly_accessible = false

  iam_database_authentication_enabled = true

  vpc_security_group_ids = data.aws_security_groups.sg_rds.ids

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  create_db_parameter_group = false
  parameter_group_name      = aws_db_parameter_group.rds_mysql_pg.name

  create_db_subnet_group = false
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
}

resource "aws_db_parameter_group" "rds_mysql_pg" {
  name   = "rds-mysql8-pg"
  family = "mysql8.0"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "1"
  }
  parameter {
    name  = "log_queries_not_using_indexes"
    value = "1"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = data.aws_subnet_ids.private.ids

  tags = {
    Name = "terra-subnet-group"
  }
}
