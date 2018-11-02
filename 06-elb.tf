
resource "aws_elb" "app_elb" {
  name               = "${terraform.workspace}-${var.project_name}-elb"
  subnets            = ["${aws_subnet.public_subnet_a.id}", "${aws_subnet.public_subnet_b.id}"]
  internal           = false
  security_groups    = ["${aws_security_group.app.id}"]

  listener     = [
        {
            instance_port     = "80"
            instance_protocol = "HTTP"
            lb_port           = "80"
            lb_protocol       = "HTTP"
        },
        {
            instance_port     = "443"
            instance_protocol = "HTTPS"
            lb_port           = "443"
            lb_protocol       = "HTTPS"
            ssl_certificate_id = "${var.ssl_certificate_id}"
        }
    ]

  health_check = [
    {
        target              = "HTTPS:443/"
        interval            = 8
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
  }
]

    tags = "${merge(
    local.common_tags,
    map(
     "Name", "${terraform.workspace}-${var.project_name}"
    )
  )}"
}
