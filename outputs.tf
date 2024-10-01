locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: "${aws_eks_cluster.cluster.name}"
  name: "${aws_eks_cluster.cluster.name}"
current-context: "${aws_eks_cluster.cluster.name}"
kind: Config
preferences: {}
users:
- name: "${aws_eks_cluster.cluster.name}"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1
      command: aws-iam-authenticator
      interactiveMode: IfAvailable
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.cluster.name}"
KUBECONFIG
}

resource "local_file" "kubeconfig" {
  filename = "kubeconfig"
  content  = local.kubeconfig
}

output "rds_endpoint" {
  description = "Endpoint do banco de dados RDS PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

#output "api_gateway_url" {
#description = "URL completa do API Gateway com o caminho da aplicação"
#value       = "${aws_apigatewayv2_api.app_http_api.api_endpoint}/restaurant/{proxy+}"
#}

output "api_gateway_dns" {
  description = "O DNS do API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}

output "client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}



