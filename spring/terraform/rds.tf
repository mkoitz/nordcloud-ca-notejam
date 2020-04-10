resource "aws_rds_cluster" "notejam" {
  cluster_identifier      = "aurora-cluster-notejam"
  engine                  = "aurora"
  engine_mode             = "serverless"
  database_name           = "notejam"
  master_username         = "notejam" // secrets manager
  //master_password         = "" // secrets manager
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  deletion_protection     = true
  enable_http_endpoint    = true

  scaling_configuration { // define production scaling config
    max_capacity           = 4
    min_capacity           = 1
  }

}