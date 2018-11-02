resource "random_string" "password_rds" {
  length  = 16
  upper   = true
  lower   = true
  number  = true
  special = false
}


resource "aws_ssm_parameter" "rds" {
  name  = "/${terraform.workspace}/rds/root_password"
  value = "${random_string.password_rds.result}"
  type  = "String"
}

resource "random_string" "openvpn_pass" {
  length  = 16
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "aws_ssm_parameter" "openvpn" {
  name  = "/${terraform.workspace}/openvpn/password"
  value = "${random_string.openvpn_pass.result}"
  type  = "String"
}

resource "aws_ssm_parameter" "openvpn_user" {
  name  = "/${terraform.workspace}/openvpn/user"
  value = "${var.openvpn_admin_user}"
  type  = "String"
}