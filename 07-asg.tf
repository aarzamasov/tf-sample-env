locals {
 local_name_ec2 = "${var.asg_name} ${var.project_name} ${terraform.workspace}"
}
resource "aws_launch_configuration" "application" {
  name_prefix                 = "${var.asg_name}-"
  image_id                    = "${var.asg_ami}"
  instance_type               = "${var.asg_instance_type}"
  key_name                    = "${var.ssh_key}"
  security_groups             = ["${aws_security_group.app.id}"]
  associate_public_ip_address = "${var.asg_associate_public_ip_address}"
  root_block_device           = "${var.asg_root_block_device}"
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "this" {
  name_prefix               = "asg-${var.asg_name}-${random_pet.asg_name.id}-"
  launch_configuration      = "${aws_launch_configuration.application.name}"
  vpc_zone_identifier       = ["${aws_subnet.private_subnet_a.id}", "${aws_subnet.private_subnet_b.id}"]
  min_size                  = "${var.asg_min_size}"
  max_size                  = "${var.asg_max_size}"
  desired_capacity          = "${var.asg_desired_capacity}"
  load_balancers            = ["${aws_elb.app_elb.id}"] 

  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "EC2"

  default_cooldown          = "${var.asg_default_cooldown}"
  termination_policies      = ["OldestInstance"]

  tags = ["${concat(
      list(map("key", "Name", "value", local.local_name_ec2, "propagate_at_launch", true)))}"]

  lifecycle {
    create_before_destroy = true
  }
}


resource "random_pet" "asg_name" {
  separator = "-"
  length    = 2
  keepers = {
    # Generate a new pet name each time we switch launch configuration
    lc_name = "${aws_launch_configuration.application.name}"
  }
}

