variable cidr_block {
    type = string
}

variable instance_tenancy {
  type        = string
}

variable int_gtw_tag {
    type = map(string)
}

variable avail_zone {
    type = string
}
variable "public_ip" {
    type = bool
}


variable "public_subnet" {
    type = list(string)
       
}
variable "private_subnet" {
    type = list(string)
       
}
variable "database_subnet" {
    type = list(string)
}

variable common_tags {
  type        = map(string)
  default     = {
    project   = "expense"
    Terraform = true
  }
}

variable env {
  type        = map
}

variable Environment {
  type        = string
}

variable project{
    type = string
    default = "Expense"
}
variable "vpc" {
    type = string
    default ="vpc"
}
variable tags {
    type = map(string)
    default = {
        Name = "EXpense-vpc"
    }
}
variable is_peering_req {
    type = bool
}
variable dest_cidr_block {
  type        = string
}


variable "practice_subnet" {
    type = map(list(string))
    default ={
       practice_subnet = ["10.0.11.0/24", "10.0.12.0/24"]
       private_sbnet = ["10.0.11.0/24", "10.0.12.0/24"]
       database_subnet = ["10.0.21.0/24", "10.0.22.0/24"]
    }
    
        # database_subnet = ["10.0.21.0/24", "10.0.22.0/24"]
}


