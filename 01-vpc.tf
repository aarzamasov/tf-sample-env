
##########################################
####             VPC
##########################################
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${merge(
    local.common_tags,
    map(
     "Name", "${var.vpc_name}-${var.project_name}-${terraform.workspace}"
    )
  )}"
}

##########################################
####             SUBNETS
##########################################
resource "aws_subnet" "public_subnet_a" {
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${var.public_a_cidr}"
  availability_zone               = "${var.a_az}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "pub-sb-${var.a_az}"
    )
  )}"
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${var.public_b_cidr}"
  availability_zone               = "${var.b_az}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "pub-sb-${var.b_az}"
    )
  )}"
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${var.private_a_cidr}"
  availability_zone               = "${var.a_az}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "priv-sb-${var.a_az}"
    )
  )}"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "${var.private_b_cidr}"
  availability_zone               = "${var.b_az}"
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = false
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "priv-sb-${var.b_az}"
    )
  )}"
}

##########################################
####             IGW
##########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "${var.igw_name}"
    )
  )}"
}

##########################################
####             NAT
##########################################
resource "aws_eip" "eip_nat_a" {
  vpc  = true
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "eip-nat-${var.region}-${var.a_az}"
    )
  )}"
}
resource "aws_nat_gateway" "nat_a" {
  allocation_id = "${aws_eip.eip_nat_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "nat-${var.region}-${var.a_az}"
    )
  )}"
}
resource "aws_eip" "eip_nat_b" {
  vpc  = true
    tags = "${merge(
    local.common_tags,
    map(
     "Name", "eip-nat-${var.region}-${var.b_az}"
    )
  )}"
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = "${aws_eip.eip_nat_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "nat-${var.region}-${var.b_az}"
    )
  )}"
}

##########################################
####             VPNGW
##########################################
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "{var.vpngw_name}"
    )
  )}"
}

##########################################
####             Routes
##########################################
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = "${merge(
    local.common_tags,
    map(
     "Name", "${var.public_rt_name}"
    )
  )}"
}

resource "aws_main_route_table_association" "public" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table" "private_a_rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_a.id}"
  }

  tags = "${merge(
    local.common_tags,
    map(
     "Name", "${var.private_rt_a_name}"
    )
  )}"
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = "${aws_subnet.private_subnet_a.id}"
  route_table_id = "${aws_route_table.private_a_rt.id}"
}

resource "aws_route_table" "private_b_rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_b.id}"
  }
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "${var.private_rt_b_name}"
    )
  )}"
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = "${aws_subnet.private_subnet_b.id}"
  route_table_id = "${aws_route_table.private_b_rt.id}"
}