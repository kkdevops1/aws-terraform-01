provider "aws" {
  region = "eu-north-1"  # Specify your desired AWS region
}

# Create VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "192.0.0.0/16"  # Replace with your desired CIDR block for the VPC

  tags = {
    Name = "example-vpc"
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "192.0.1.0/24"  # Replace with your desired CIDR block for the subnet
  availability_zone = "eu-north-1a"  # Replace with your desired availability zone

  tags = {
    Name = "example-subnet"
  }
}

# Create a route table and associate it with the subnet
resource "aws_route_table" "example_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-rt"
  }
}

resource "aws_route_table_association" "example_rta" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_rt.id
}

# Create security group for EC2 instance
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "example-sg"
  }
}

# Launch an EC2 instance in the subnet with the specified security group
resource "aws_instance" "example_instance" {
  ami           = "ami-0c0e147c706360bd7"  # Example AMI, replace with your desired AMI ID
  instance_type = "t3.nano"  
  subnet_id     = aws_subnet.example_subnet.id
  key_name      = "maven-key" 

  vpc_security_group_ids = [aws_security_group.example_sg.id]

  tags = {
    Name = "example-instance"
  }
}

