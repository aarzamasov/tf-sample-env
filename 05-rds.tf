resource "aws_db_subnet_group" "rds" {
  name        = "subgr-${local.rds_identifier}"
  description = "RDS main group of subnets"
  subnet_ids  = ["${aws_subnet.private_subnet_a.id}", "${aws_subnet.private_subnet_b.id}"]
}

resource "aws_db_parameter_group" "rds" {
  name_prefix = "parametr-gr-${local.rds_identifier}"
  family      = "${var.rds_default_parameter_group_family}"
  description = "${local.rds_name}"
  parameter   = "${var.rds_default_db_parameters}"
}

resource "aws_db_instance" "rds" {
  identifier                = "${local.rds_identifier}"
  allocated_storage         = "${var.rds_storage}"
  engine                    = "${var.rds_engine}"
  engine_version            = "${var.rds_engine_version}"
  instance_class            = "${var.rds_instance_type}"
  storage_type              = "${var.rds_storage_type}"
  username                  = "root"
  password                  = "${random_string.password_rds.result}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.rds.id}"
  parameter_group_name      = "${aws_db_parameter_group.rds.id}"
  multi_az                  = "${var.rds_multi_az}"
  backup_retention_period   = "${var.rds_backup_retention_period}"
  storage_encrypted         = "false"
  apply_immediately         = "true"
  skip_final_snapshot       = "false"
  final_snapshot_identifier = "${local.rds_identifier}-final-${md5(timestamp())}"
  
  tags = "${merge(
    local.common_tags,
    map(
     "Name", "RDS ${local.rds_name}"
    )
  )}"

  lifecycle {
    ignore_changes = ["final_snapshot_identifier"]
  }
}


resource "aws_db_instance" "rds_slave" {
  identifier                = "${local.rds_identifier}-slave"
  engine                    = "${var.rds_engine}"
  instance_class            = "${var.rds_instance_type_slave}"
  vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
  replicate_source_db       = "${aws_db_instance.rds.id}"
  storage_encrypted         = "false"
  skip_final_snapshot       = "true"

  tags = "${merge(
    local.common_tags,
    map(
     "Name", "RDS ${local.rds_name} Slave"
    )
  )}"

  lifecycle {
    ignore_changes = ["replicate_source_db"]
  }
}





locals {
  rds_name       = "${var.project_name} ${terraform.workspace} MySql v.${var.rds_engine_version}",
  rds_identifier = "${var.project_name}-${terraform.workspace}-mysql"
}