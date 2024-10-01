import json
import boto3
import os
import uuid

# Inicializa o cliente do Cognito
client = boto3.client('cognito-idp')

# Acessa as variáveis de ambiente
USER_POOL_ID = os.environ['USER_POOL_ID']
CLIENT_ID = os.environ['CLIENT_ID']

def lambda_handler(event, context):
    # Extrair dados do corpo da requisição (JSON)
    body = json.loads(event['body'])

    email = body.get('email')
    password = body.get('password')
    cpf = body.get('cpf')

    if not email or not password or not cpf:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'email, password e cpf são obrigatórios.'})
        }

    # Gerar um nome de usuário único (UUID) ou outro identificador
    username = str(uuid.uuid4())  # Gera um UUID único para o username

    # Tentar criar o usuário no Cognito
    try:
        response = client.sign_up(
            ClientId=CLIENT_ID,
            Username=username,  # Usar o UUID como username
            Password=password,
            UserAttributes=[
                {'Name': 'email', 'Value': email},  # E-mail como atributo
                {'Name': 'custom:cpf', 'Value': cpf},
            ]
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Usuário registrado com sucesso.', 'data': response})
        }

    except client.exceptions.UsernameExistsException:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Usuário já existe.'})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': f'Erro ao registrar o usuário: {str(e)}'})
        }
