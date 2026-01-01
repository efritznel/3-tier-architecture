# create sg for alb internet access
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow internet access to ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "alb-sg"
    }
}

# create sg for web access from alb
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow access to web servers from ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "web-sg"
    }
}

# create sg for internal alb access
resource "aws_security_group" "internal_alb_sg" {
  name        = "internal-alb-sg"
  description = "Allow access to internal ALB"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "internal-alb-sg"
    }
}

# create sg for app access from web servers
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow access to app servers from web servers"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.internal_alb_sg.id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "app-sg"
    }
}

# create sg for db access from app servers
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow access to db servers from app servers"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
    Name = "db-sg"
    }
}

