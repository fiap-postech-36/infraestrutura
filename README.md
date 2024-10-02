
# FIAP Software Architecture - (GRUPO 36 - 6SOAT)
🔥 Desafio Tech Challenge Fase 03


## Desenho Arquitetura Utilizada 👋

![desenho_infra](https://github.com/user-attachments/assets/f47102d0-7780-43bc-a49b-220d3fa75343)


## Stack utilizada

👩‍💻 Tecnologias:	

    ✅ Backend:
            Java: Linguagem de programação principal.
            Maven: Ferramenta de gerenciamento de dependências e build.
            Spring: Framework para desenvolvimento de aplicações Java, como Spring Boot.

    ✅ Banco de Dados:
            Postgres: Banco de dados relacional utilizado no projeto.
            RDS: Serviço de banco de dados gerenciado da AWS, usado para hospedar o Postgres.

    ✅ DevOps e Infraestrutura:
            Docker: Ferramenta de containerização para isolar ambientes e empacotar aplicações.
            Kubernetes (EKS): Orquestrador de contêineres, usando o Elastic Kubernetes Service (EKS) da AWS para gerenciar os clusters.        
            Terraform: Ferramenta de infraestrutura como código (IaC) para gerenciar os recursos da AWS e outros provedores de nuvem.
            EC2: Instâncias de máquinas virtuais na AWS.
            Load Balancer: Balanceador de carga para distribuir o tráfego entre as instâncias de EC2 ou contêineres no EKS.

    ✅ CI/CD:
        Github Action: Ferramenta para integração contínua e entrega contínua (CI/CD), gerenciando pipelines de build, teste e deploy.

    ✅ Autenticação e Segurança:
        Cognito: Serviço de autenticação, autorização e gerenciamento de usuários da AWS.
        Lambda authorizer: Função Lambda utilizada para autorizar o acesso aos recursos da API.

    ✅ Rede:
        API Gateway: Serviço de gerenciamento de APIs que atua como interface de entrada para os clientes
## Rodando o projeto localmente com terraform
### Instalação do Terraform
Antes de começar, você precisa ter o [Terraform](https://www.terraform.io/downloads.html) instalado em sua máquina.

Para instalar o Terraform, siga os passos:

    1. Acesse a [página de downloads do Terraform](https://www.terraform.io/downloads.html).
    2. Baixe a versão adequada para o seu sistema operacional.
    3. Siga as instruções de instalação fornecidas na página do terraform. 

    Executando o Terraform:
      Inicialize o Terraform no diretório de infraestrutura: 
      comando: terraform init
      
      Em seguida, crie o plano de execução, onde o Terraform vai analisar o que será criado ou modificado:
      comando: terraform plan
      
      Por fim, aplique as alterações para criar a infraestrutura: 
      comando: terraform apply
    
## Demonstração do funcionamento da aplicação
Segue link do vídeo que explica os seguintes pontos:

Terraform criados para a estrutura que é montada
Processo em cada um dos repositório com github actions
Estrutura de login
Estrutura Functions
Estrutura Database
Estrutura aplicação

Link: https://xxxxxxxxxxxxxxxxxxxxxxx


## Autores

- Leandro Ibraim: [@leandroibraim](https://github.com/leandroibraim)
- Jorge Bazara Jr [@jjbazagajr](https://github.com/jjbazagajr)
- Ulysses de Castro [@ulysses903]( https://github.com/ulysses903)
- Kaique Santos [@KaiqueSantos98](https://github.com/KaiqueSantos98)
- Samuel Teixeira [@Samuel M. Teixeira](https://github.com/SamuelMTeixeira)
 
