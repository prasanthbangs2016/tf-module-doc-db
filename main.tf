resource "aws_docdb_cluster" "docdb" {
  #cluster-name
  cluster_identifier      = "Roboshop-${var.env}"
  engine                  = "docdb"
  engine_version          = var.engine_version
  master_username         = local.username
  master_password         = local.password
#  backup_retention_period = 5
#  preferred_backup_window = "07:00-09:00"
  #when u try to delete cluster it will delete automatically  with kind of back up
  skip_final_snapshot     = true

  tags = {
    Name = "Roboshop-${var.env}"
  }
}
#creating cluster in db subnets

#resource "aws_docdb_subnet_group" "default" {
#  name       = "main"
#  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]
#
#  tags = {
#    Name = "Roboshop-${var.env}"
#  }
#}

output "out" {
  value = module.vpc.out
}