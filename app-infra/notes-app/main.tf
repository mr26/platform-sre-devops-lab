module "rds" {
  source = "./rds"
  aws_region = var.aws_region
  vpc_id = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  initial_db_name = var.initial_db_name
  db_username = var.db_username
  db_name = var.db_name
}

module "iam" {
  source = "./iam"
  cluster_name = var.cluster_name
  namespace = var.namespace
  service_account_name = var.service_account_name
  iam_role_name = var.iam_role_name
  region = var.region
  db_username = var.db_username
  db_resource_id   = module.rds.db_resource_id
}
