data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "mehdi-platform-tf-state"
    key    = "notes-app-db/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "mehdi-platform-tf-state"
    key    = "notes-app-iam/terraform.tfstate"
    region = "us-east-1"
  }
}

module "rds" {
  source = "./rds"
  aws_region = module.rds.aws_region
  vpc_id = module.rds.vpc_id
  private_subnet_ids = module.rds.private_subnet_ids
  initial_db_name = module.rds.initial_db_name
  db_username = module.rds.db_username
  db_name = module.rds.db_name
}

module "iam" {
  source = "./iam"
  cluster_name = module.iam.cluster_name
  namespace = module.iam.namespace
  service_account_name = module.iam.service_account_name
  iam_role_name = module.iam.iam_role_name
  region = module.iam.region
  tf_state_bucket = module.iam.tf_state_bucket
  rds_state_key = module.iam.rds_state_key
  db_username = module.iam.db_username
  db_resource_id   = module.rds.db_resource_id

}
