############################
# EKS cluster info
############################

cluster_name         = "mgmt-cluster"
namespace            = "notes-app"
service_account_name = "notes-app-sa"
iam_role_name        = "notes-app-irsa-role"
region               = "us-east-1"

############################
# RDS
############################

tf_state_bucket      = "mehdi-platform-tf-state"
rds_state_key        = "notes-app-db/terraform.tfstate"
db_username          = "admin"
