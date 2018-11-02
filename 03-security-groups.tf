resource "aws_security_group" "bastion" {
  name = "bastion ${local.add_to_names}"
  description = "Allow SSH access to Bastion host"
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.cidr_blocks_allow}"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 943
    to_port     = 943
    cidr_blocks = ["${var.cidr_blocks_allow}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "bastion ${local.add_to_names}"
    )
  )}"
}
resource "aws_security_group" "app" {
  name = "application ${local.add_to_names}"
  description = "Allow  access to Application host"
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3389
    to_port     = 3389
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "application ${local.add_to_names}"
    )
  )}"
}

resource "aws_security_group" "rds" {
  name = "rds ${local.add_to_names}"
  description = "Allow access to RDS host"
  ingress {
    protocol    = "TCP"
    from_port   = 3306
    to_port     = 3306
    security_groups = ["${aws_security_group.app.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "rds ${local.add_to_names}"
    )
  )}"
}