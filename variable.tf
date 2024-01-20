variable "common_tags" {
  type = map
  default = {}
}

variable "vpc_tags" {
  type = map 
  default = {}
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "igw_tags" {
  type = map 
  default = {}
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
  validation {
    condition = length(var.public_subnet_cidrs) == 2
    error_message = "Please enter two valid public CIDR's"
  }
}

variable "private_subnet_cidrs" {
  type = list(string)
  validation {
    condition = length(var.private_subnet_cidrs) == 2
    error_message = "Please enter two valid private CIDR's"
  }
}

variable "database_subnet_cidrs" {
  type = list(string)
  validation {
    condition = length(var.database_subnet_cidrs) == 2
    error_message = "Please enter two valid private CIDR's"
  }
}

variable "isPeeringRequired" {
  type = bool
  default = false
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
}