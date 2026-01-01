# create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "my-vpc"
  }
}

# Create public subnet in AZ1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# Create public subnet in AZ2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
    availability_zone       = var.az2
    map_public_ip_on_launch = true
    tags = {
    Name = "public-subnet-2"
    }
}

# Create private subnet for web in AZ1
resource "aws_subnet" "private_web_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
    availability_zone = var.az1
    tags = {
    Name = "private-web-subnet-1"
    }
}
# Create private subnet for web in AZ2
resource "aws_subnet" "private_web_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
    availability_zone = var.az2
    tags = {
    Name = "private-web-subnet-2"
    }
}

# Create private subnet for app in AZ1
resource "aws_subnet" "private_app_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
    availability_zone = var.az1
    tags = {
    Name = "private-app-subnet-1"
    }
}

# Create private subnet for app in AZ2
resource "aws_subnet" "private_app_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"
    availability_zone = var.az2
    tags = {
    Name = "private-app-subnet-2"
    }
}

# Create private subnet for db in AZ1
resource "aws_subnet" "private_db_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.6.0/24"
    availability_zone = var.az1
    tags = {
    Name = "private-db-subnet-1"
    }
}

# Create private subnet for db in AZ2
resource "aws_subnet" "private_db_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.7.0/24"
    availability_zone = var.az2
    tags = {
    Name = "private-db-subnet-2"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public-rt"
  }
}
# Create Route to Internet Gateway in Public Route Table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id    
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# Create NAT Gateway in Public Subnet 1
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "nat-gw"
  }
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private-rt"
  }
}

# Create Route to NAT Gateway in Private Route Table
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_web_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_web_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_web_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_web_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_app_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_app_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_app_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_app_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_db_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_db_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}