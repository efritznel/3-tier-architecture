variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az1" {
  description = "The first availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "The second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "db_username" {
  description = "database user name"
  type = string
  default     = "admin"
}