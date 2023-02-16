resource "aws_ssm_parameter" "docdb-url" {
  name  = "'mutable.docdb.{ENV}.MONGO_URL"
  type  = "String"
  value = "mongodb://${local.username}:${local.password}@roboshop-dev.cluster-cjsux0hozm9j.us-east-1.docdb.amazonaws.com:27017/catalogue?"
}