resource "aws_docdb_cluster" "docdb" {
  #cluster-name
  cluster_identifier      = "roboshop-${var.env}"
  engine                  = "docdb"
  engine_version          = var.engine_version
  master_username         = local.username
  master_password         = local.password
#  backup_retention_period = 5
#  preferred_backup_window = "07:00-09:00"
  #when u try to delete cluster it will delete automatically  with kind of no back up
  skip_final_snapshot     = true
  db_subnet_group_name = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  vpc_security_group_ids = [aws_security_group.docdb.id]

  tags = {
    Name = "Roboshop-${var.env}"
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class
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
  vpc_id      = var.vpc_id

  ingress {
    description      = "docdb"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block,var.WORKSTATION_IP]

  }


  tags = {
    Name = "Roboshop-${var.env}-docdb"
  }
}

resource "null_resource" "mongo_schema_apply" {
  provisioner "local-exec" {
    command = <<EOF
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
cd /tmp
unzip mongodb.zip
cd mysql-main
curl -L -O https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
mongo --ssl --host ${aws_docdb_cluster.docdb.endpoint}:27017 --sslCAFile rds-combined-ca-bundle.pem --username ${local.username} --password ${local.password} <catalogue.js
mongo --ssl --host ${aws_docdb_cluster.docdb.endpoint}:27017 --sslCAFile rds-combined-ca-bundle.pem --username ${local.username} --password ${local.password} <users.js
EOF

  }
}



