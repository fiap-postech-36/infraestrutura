# API Gateway Rest API
resource "aws_api_gateway_rest_api" "api" {
  name        = "RestaurantAPI"
  description = "API Gateway para rotear para o Load Balancer do Kubernetes"
}

# Criação do recurso root "/"
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}" # Proxy para todas as rotas
}

# Definir método para aceitar todas as rotas e passar parâmetros
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

# Criar a integração com o Load Balancer
resource "aws_api_gateway_integration" "lb_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  type        = "HTTP_PROXY"

  uri = "http://${kubernetes_service.load-balancer-restaurant-api.status[0].load_balancer[0].ingress[0].hostname}:8080/{proxy}" # DNS do Load Balancer criado

  integration_http_method = "ANY"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# Criar o recurso /signup
resource "aws_api_gateway_resource" "signup" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "signup"
}

# Método POST no recurso /signup
resource "aws_api_gateway_method" "post_signup" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.signup.id
  http_method   = "POST"
  authorization = "NONE" # Ajuste isso se precisar de autorização para proteger a rota

  request_models = {
    "application/json" = "Empty"
  }
}

# Integração da Lambda no API Gateway
resource "aws_api_gateway_integration" "lambda_signup_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.signup.id
  http_method             = aws_api_gateway_method.post_signup.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.cognito_signup.invoke_arn
}

# Permitir que o API Gateway invoque a função Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cognito_signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Deploy da API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_signup_integration, aws_api_gateway_integration.lb_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}



