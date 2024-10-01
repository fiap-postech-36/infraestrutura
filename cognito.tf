resource "aws_cognito_user_pool" "user_pool" {
  name = "my_user_pool"

  # Definir alias como email ou telefone
  alias_attributes = ["email"]

  # Criar um atributo personalizado para o CPF
  schema {
    attribute_data_type = "String"
    name                = "cpf"
    required            = false
    mutable             = false
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }

  # Configurações de políticas de senha
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Auto-verificação por email
  auto_verified_attributes = ["email"]
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "restaurant_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  depends_on = [aws_cognito_user_pool.user_pool]
}
