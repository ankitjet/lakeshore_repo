resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = merge(
    { Name = "vpc-${local.name_suffix}" },
    local.tags
  )

}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 0)
  availability_zone = data.aws_availability_zone.az1.name
  tags = merge(
    { Name = "priv1-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 1)
  availability_zone = data.aws_availability_zone.az1.name
  tags = merge(
    { Name = "pub1-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 2)
  availability_zone = data.aws_availability_zone.az2.name
  tags = merge(
    { Name = "priv2-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, 3)
  availability_zone = data.aws_availability_zone.az2.name
  tags = merge(
    { Name = "pub2-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route  = []
  tags = merge(
    { Name = "pubrt-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  }

  tags = merge(
    { Name = "privrt1-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  }

  tags = merge(
    { Name = "privrt2-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "igw-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_route_table_association" "public1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public1.id
}

resource "aws_route_table_association" "public2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public2.id
}

resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.private1.id
  subnet_id      = aws_subnet.private1.id
}

resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.private2.id
  subnet_id      = aws_subnet.private2.id
}

resource "aws_security_group" "main" {
  vpc_id      = aws_vpc.main.id
  name        = replace("sg-${local.name_suffix}", "-", "_")
  description = "terraform managed security group"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(
    { name = "vpc-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-west-2.s3"

  tags = merge(
    { name = "vpce-${local.name_suffix}" },
    local.tags
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw" {
  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]
  dns_support        = "enable"
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.main.id

  tags = merge(
    { Name = "tgwa-${local.name_suffix}" },
    local.tags
  )
}
