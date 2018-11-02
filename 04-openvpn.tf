resource "aws_eip" "openvpn" {
  instance = "${aws_instance.openvpn.id}"
  vpc      = true
}

resource "aws_instance" "openvpn" {
  ami           = "${var.openvpn_ami}"
  instance_type = "${var.openvpn_instance_type}"
  key_name      = "${var.ssh_key}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"

  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags = "${merge(
    local.common_tags,
    map(
     "Name", "openvpn-${var.project_name}-${terraform.workspace}"
    )
  )}"

  user_data = <<USERDATA
        admin_user=${var.openvpn_admin_user}
        admin_pw=${random_string.openvpn_pass.result}
        USERDATA
}

resource "aws_iam_instance_profile" "openvpn" {
  name = "${var.openvpn_name}-${var.project_name}-${terraform.workspace}"
  role = "${aws_iam_role.openvpn.name}"
}

resource "aws_iam_role" "openvpn" {
  name = "${var.openvpn_name}-${var.project_name}-${terraform.workspace}"
  assume_role_policy = "${file("${path.module}/policy/ec2-trust.json")}"
}
