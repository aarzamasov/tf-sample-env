locals {
  id = "${replace(var.cfn_name, " ", "-")}-${replace(var.project_name, " ", "-")}-${replace(terraform.workspace, " ", "-")}"
}

resource "aws_cloudfront_distribution" "application" {
  origin {
    domain_name = "${aws_elb.app_elb.dns_name }"
    origin_id   = "${local.id}"
    custom_origin_config = ["${var.cfn_custom_origin_config}"]
  }

  enabled = true
  comment = "${var.cfn_name} ${var.project_name} ${terraform.workspace}"
  aliases = "${var.cfn_aliases}"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.id}"
    compress = true

    forwarded_values {
      query_string = true
      headers = ["${var.cfn_forwarded_headers}"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 604800
  }
  viewer_certificate {
    acm_certificate_arn            = "${var.ssl_certificate_id}"
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.1_2016"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = "${merge(
    local.common_tags,
    map(
     "Name", "cloudfront ${var.project_name} ${terraform.workspace}"
    )
  )}"
}


