##########################################
####             COMMON
##########################################
variable "region" {}  
variable "project_name" {}  
variable "ssh_key" {}
variable "ssl_certificate_id" {}

##########################################
####          01 VPC
##########################################
variable "vpc_cidr" {}          
variable "a_az" {}            
variable "b_az" {}            
variable "public_a_cidr" {}     
variable "public_b_cidr" {}     
variable "private_a_cidr" {}     
variable "private_b_cidr" {}     
variable "vpc_name" {} 
variable "igw_name" {} 
variable "vpngw_name" {}       
variable "public_rt_name" {} 
variable "private_rt_a_name" {} 
variable "private_rt_b_name" {} 


##########################################
####          03  SECURITY GROUPS
##########################################
variable "cidr_blocks_allow" {
    description = "CIDR blocks for allowing to specific port"
    default = []
}

##########################################
####          04  OPENVPN
##########################################
variable "openvpn_instance_type" {}
variable "openvpn_admin_user" {}
variable "openvpn_name" {}
variable "openvpn_ami" {}

####################################
#####  RDS
###################################
variable "rds_instance_type" {}   
variable "rds_instance_type_slave" {}                
variable "rds_multi_az" {}                   
variable "rds_engine" {}                     
variable "rds_engine_version" {}              
variable "rds_default_parameter_group_family" {}
variable "rds_storage" {}                  
variable "rds_storage_type" {}             
variable "rds_backup_retention_period" {} 

variable "rds_default_db_parameters" {
  default = [
      {
        name  = "slow_query_log"
        value = "1"
      },
      {
        name  = "long_query_time"
        value = "1"
      },
      {
        name  = "general_log"
        value = "0"
      },
      {
        name  = "log_output"
        value = "FILE"
      }
    ]
}




####################################
#####  Autoscaling group
###################################
variable "asg_min_size" {}                 
variable "asg_max_size" {}                 
variable "asg_desired_capacity" {}         
variable "asg_instance_type" {}
variable "asg_ami" {}                        
variable "asg_health_check_grace_period" {}  
variable "asg_default_cooldown" {}           
variable "asg_name" {}                       
variable "asg_launch_name" {}                
variable "asg_associate_public_ip_address" {}
variable "asg_root_block_device" {
    default=[]
}

####################################
#####  CloudFront
###################################
variable "cfn_name" {}
variable "cfn_origin" {
}
variable "cfn_aliases" {
  default=[]
}
variable "cfn_custom_origin_config" {
  default=[]
}
variable "cfn_forwarded_headers" {
  default=[]
}