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
  cognito_secret_arn = module.iam.secret_arn
  cognito_user_pool_arn = module.iam.user_pool_arn
}
