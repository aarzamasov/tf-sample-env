locals {
  common_tags = "${map(
    "project_name", "${var.project_name}",
    "Stage", "${terraform.workspace}"
  )}"
}

locals {
 add_to_names = " ${var.project_name} ${terraform.workspace}"
}