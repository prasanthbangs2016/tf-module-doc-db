resource "aws_ssm_parameter" "docdb-url-catalogue" {
  name  = "mutable.docdb.catalogue.${var.env}.MONGO_URL"
  type  = "String"
  value = "mongodb://${local.username}:${local.password}@${aws_docdb_cluster.docdb.endpoint}:27017/catalogue?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
}


resource "aws_ssm_parameter" "docdb-url-users" {
  name  = "mutable.docdb.user.${var.env}.MONGO_URL"
  type  = "String"
  value = "mongodb://${local.username}:${local.password}@${aws_docdb_cluster.docdb.endpoint}:27017/users?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
}