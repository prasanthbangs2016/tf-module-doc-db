resource "aws_docdb_cluster" "docdb" {
  #cluster-name
  cluster_identifier      = "roboshop-${var.env}"
  engine                  = "docdb"
  engine_version          = var.engine_version
  master_username         = local.username
  master_password         = local.password
#  backup_retention_period = 5
#  preferred_backup_window = "07:00-09:00"
  #when u try to delete cluster it will delete automatically  with kind of back up
  skip_final_snapshot     = true
  db_subnet_group_name = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  vpc_security_group_ids = [aws_security_group.docdb.id]

  tags = {
    Name = "Roboshop-${var.env}"
  }
}
#creating cluster in db subnets

resource "aws_docdb_subnet_group" "main" {
  name       = "roboshop-${var.env}"
  subnet_ids = var.apps_subnet_ids

  tags = {
    Name = "Roboshop-${var.env}"
  }
}

#creating db configuration using parameter group

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb4.0"
  name        = "roboshop-${var.env}"
  description = "roboshop-${var.env}"

#  parameter {
#    name  = "tls"
#    value = "enabled"
#  }
}

#creating security group for db

resource "aws_security_group" "docdb" {
  name        = "roboshop-${var.env}-docdb"
  description = "roboshop-${var.env}-docdb"
  vpc_id      = module.vpc.id

  ingress {
    description      = "docdb"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block]

  }


  tags = {
    Name = "Roboshop-${var.env}-docdb"
  }
}

