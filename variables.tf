variable "aws_access_key" {
    description = "Amazon access key for terraform user"
}
variable "aws_secret_key" {
    description = "Amazon secret key for terraform user"
}

variable "aws_key_name" {
	default = "hive-key"
}

variable "aws_key_path" {
	default = "keys/hive-key.pub"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "aws_availability_zone" {
    description = "EC2 Region for the VPC"
    default = "us-east-1a"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "172.31.159.0/24"
}

variable "forwarding_config" {
  default = {
      "80"        =   "TCP"
      "443"       =   "TCP"
  }
}