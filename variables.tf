variable "prefix" {
  description = "Prefix for resources"
  type        = string
  default = "fiap-01"
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "fiap-eks-cluster"
}
variable "retentions_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 7
}
variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}
variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}
variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}
variable "db_password" {
  description = "Password for RDS"
  type        = string
  sensitive   = true
  default = "postgres"
}
variable "db_name" {
  description = "Name of the RDS database"
  type        = string
  default = "restaurant"
}

variable "db_user" {
  description = "Username for RDS"
  type        = string
  default = "postgres"
}
variable "kubeconfig" {
  description = "Kubeconfig file"
  type        = string
}
