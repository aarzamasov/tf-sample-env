####################################
#####  COMMON 
###################################
region               = "us-east-1"
project_name         = "justocean"
ssh_key              = "keypair"
ssl_certificate_id   = "arn here"

####################################
#####  VPC
###################################
vpc_cidr          = "10.89.0.0/16"
public_a_cidr     = "10.89.2.0/24"
public_b_cidr     = "10.89.3.0/24"
private_a_cidr    = "10.89.12.0/24"
private_b_cidr    = "10.89.13.0/24"
a_az              = "us-east-1a"
b_az              = "us-east-1b"
vpc_name          = "vpc"
igw_name          = "igw"
vpngw_name        = "vpn-gateway"
public_rt_name    = "public-rt"
private_rt_a_name = "private-rt-a"
private_rt_b_name = "private-rt-b"

####################################
#####  Security Groups
###################################
cidr_blocks_allow = ["83.26.203.13/32", "81.26.203.13/32"]

####################################
#####  Open VPN
###################################
openvpn_instance_type  = "t2.micro"
openvpn_admin_user     = "adminopenvpn"
openvpn_name           = "openvpn"
openvpn_ami            = "ami-1b9c4966"

####################################
#####  RDS
###################################
rds_instance_type                   = "db.t2.small"
rds_instance_type_slave             = "db.t2.small"
rds_multi_az                        = true
rds_engine                          = "mysql"
rds_engine_version                  = "5.7.17"
rds_default_parameter_group_family  = "mysql5.7"
rds_storage                         = "500"
rds_storage_type                    = "gp2"
rds_backup_retention_period         = "14"


####################################
#####  ELB
###################################
elb_name = "elb"

####################################
#####  Autoscaling group
###################################
asg_min_size                        = 0
asg_max_size                        = 1
asg_desired_capacity                = 1
asg_instance_type                   = "t2.medium"
asg_ami                             = "any ami id here"
asg_health_check_grace_period       = 600
asg_default_cooldown                = 300
asg_name                            = "application-asg"
asg_launch_name                     = "applicattion-lc"

asg_associate_public_ip_address     = false
asg_root_block_device = [
    {
      volume_size           = "150"
      volume_type           = "gp2"
      delete_on_termination = true
    },
]


####################################
#####  CloudFront
###################################
cfn_name    = "clf"
cfn_origin  = "${aws_elb.app_elb.id}"
cfn_aliases = []
cfn_custom_origin_config = [{
  http_port  = 80
  https_port = 443
  origin_protocol_policy = "http-only"
  origin_ssl_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
  origin_read_timeout = 60
}]
cfn_forwarded_headers = ["Host"]
