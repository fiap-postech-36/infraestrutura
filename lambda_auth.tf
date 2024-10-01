
resource "aws_iam_role" "lambda_cognito_role" {
  name = "lambda_cognito_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Permissões para a Lambda interagir com o Cognito
resource "aws_iam_policy" "lambda_cognito_policy" {
  name = "lambda_cognito_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:SignUp",
          "cognito-idp:AdminCreateUser"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_cognito_role.name
  policy_arn = aws_iam_policy.lambda_cognito_policy.arn
}

# Função Lambda que fará o cadastro no Cognito
resource "aws_lambda_function" "cognito_signup" {
  function_name = "cognito_signup"
  role          = aws_iam_role.lambda_cognito_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.9"
  filename      = "handler.zip" # Substitua pelo caminho do seu ZIP

  # Variáveis de ambiente (opcional para facilitar configurações)
  environment {
    variables = {
      USER_POOL_ID = aws_cognito_user_pool.user_pool.id
      CLIENT_ID    = aws_cognito_user_pool_client.user_pool_client.id
    }
  }
  depends_on = [aws_cognito_user_pool_client.user_pool_client]
}
