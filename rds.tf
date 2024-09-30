# Atualizando o Security Group para permitir acesso remoto
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.new-vpc.id

  # Permitir tráfego de entrada na porta 5432 de qualquer IP (0.0.0.0/0)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir acesso de qualquer IP
  }

  # Permitir todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-rds-sg"
  }
}

# Subnet group para o RDS (usando suas subnets públicas/privadas)
resource "aws_db_subnet_group" "rds_subnet_groups" {
  name       = "${var.prefix}-rds-subnet-groups"
  subnet_ids = aws_subnet.subnets.*.id

  tags = {
    Name = "${var.prefix}-rds-subnet-groups"
  }
}

# Criação do RDS PostgreSQL com acesso público
resource "aws_db_instance" "postgres" {
  identifier                = "${var.prefix}-restaurante-rds" # Definindo o identificador do banco
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "16.2"        # Ajuste a versão conforme necessário
  instance_class            = "db.t3.micro" # Tipo de instância do RDS
  username                  = var.db_user
  password                  = var.db_password
  db_name                   = var.db_name # Nome do banco de dados inicial
  publicly_accessible       = true
  skip_final_snapshot       = false                            # Não pular o snapshot final
  final_snapshot_identifier = "restaurante-rds-final-snapshot" # Identificador único para o snapshot                           # Permitir que o banco seja acessado publicamente
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]   # Usar o SG atualizado
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_groups.name


  tags = {
    Name = "${var.prefix}-postgres-rds"
  }

  depends_on = [aws_security_group.rds_sg, aws_db_subnet_group.rds_subnet_groups]
}
