data "aws_availability_zones" "available" { }

resource "aws_vpc" "eks" {
  cidr_block = var.cidr_block

  tags = {
    "Name"                                      = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "eks" {
  count                   = var.number_of_subnets
  #checkov:skip=CKV_AWS_130:In production, this would be disabled, as we would use a host bastion
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.eks.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.eks.id

  tags = {
    "Name"                                      = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_route_table" "eks" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }
}

resource "aws_route_table_association" "eks" {
  count          = var.number_of_subnets

  subnet_id      = aws_subnet.eks[count.index].id
  route_table_id = aws_route_table.eks.id
}
