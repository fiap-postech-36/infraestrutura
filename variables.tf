variable "prefix" {}
variable "cluster_name" {}
variable "retentions_days" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "db_password" {
  description = "Password for RDS"
  type        = string
  sensitive   = true
}
variable "db_name" {}

variable "db_user" {}

variable "kubeconfig" {}
