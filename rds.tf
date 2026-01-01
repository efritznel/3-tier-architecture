# Create a random password for the database
resource "random_password" "db" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create Secrets Manager secret to store the database password
resource "aws_secretsmanager_secret" "db_password" {
  name = "ithomelab/mysql/password"

  tags = {
    Name = "ithomelab-mysql-password"
  }
}

# Create a secret version with the generated password
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db.result
}

# Create DB subnet group
resource "aws_db_subnet_group" "db" {
  name       = "ithomelab-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_subnet_1.id,
    aws_subnet.private_db_subnet_2.id
  ]

  tags = {
    Name = "ithomelab-db-subnet-group"
  }
}

# Create RDS instance
resource "aws_db_instance" "default" {
  identifier        = "ithomelab-mysql"
  allocated_storage = 20

  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"

  db_name  = "mydb"
  username = var.db_username
  password = aws_secretsmanager_secret_version.db_password.secret_string

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  multi_az = true  # <-- ADD THIS (AWS creates the standby automatically)

  tags = {
    Name = "MyRDSInstance"
  }
}