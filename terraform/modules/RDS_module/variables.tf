variable "allocated_storage" {
  type        = string
  description = "allocated_storage"
  default     = "10"
}

variable "db_name" {
    type        = string
    description = "the database name"
    default     = "mydb"
}

variable "instance_class" {
    type        = string
    description = "instanse class"
    default     = "db.t3.micro"
}

variable "parameter_group_name" {
    type        = string
    description = "parameter group name"
    default     = "default.mysql5.7"
}

variable "engine" {
    type        = string
    description = "engine name"
    default     = "mysql"
}

variable "engine_version" {
    type        = string
    description = "engine version"
    default     = "5.7"
}

variable "Private_Subnet1" {
  type = string
}


variable "Private_Subnet2" {
  type = string
}

variable "mail" {
  type        = string
  description = "username"
  default     = "ahmed.m.salem2020@outlook.com"
}

variable "RDSSecurityGroup" {
  type        = string
  description = " the sg of the RDS"
}