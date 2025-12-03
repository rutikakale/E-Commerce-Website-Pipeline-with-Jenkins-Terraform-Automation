
provider "aws" {
  region = "ap-south-1"
}
variable "db_password" {}
variable "my_ip_cidr" {
  default = "0.0.0.0/0"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "db_name" {
  default = "ecommersdb"
}
variable "db_username" {
  default = "appuser"
}
variable "allocated_storage" {
  default = 20
}
# Get default VPC
data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}
# use select the latest ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] 
  }
}
#ecommers server security group
resource "aws_security_group" "server_sg" {
  name   = "server-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "ecommers-server-sg"
  }
}
# RDS security group
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommers-rds-sg"
  }
}
# Create a new subnet in a different availability zone for RDS 
resource "aws_subnet" "new_az" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.128.0/20"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ecommers-new-subnet-ap-south-1a"
  }
}
# RDS subnet group
resource "aws_db_subnet_group" "db_subnets" {
  name       = "ecommers-db-subnet-group"
  subnet_ids = [
    "subnet-09863ed04e8f2240d",  # existing ap-south-1c
    aws_subnet.new_az.id         # new ap-south-1a
  ]

  tags = {
    Name = "ecommers-db-subnet-group"
  }
}
# RDS instance
resource "aws_db_instance" "ecommers_db" {
  identifier              = "ecommers-db"
  allocated_storage       = var.allocated_storage
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "ecommers-rds"
  }
}
# EC2 instance for ecommers server
resource "aws_instance" "ecommers_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type

  subnet_id              = aws_subnet.new_az.id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.server_sg.id]
  key_name               = "terraform" # Ensure this key pair exists in your AWS account
  

  tags = {
    Name = "ecommers-server"
  }
}

output "server_public_ip" {
  value = aws_instance.ecommers_server.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.ecommers_db.address
}
