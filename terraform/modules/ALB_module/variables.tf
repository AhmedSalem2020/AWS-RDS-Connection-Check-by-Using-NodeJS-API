variable "ALB" {
  type = list
}

variable "Public_Subnet1" {
  type = string
}


variable "Public_Subnet2" {
  type = string
}

variable "vpc_id" {
  type = string
}


variable "mail" {
  type        = string
  description = "username"
  default     = "ahmed.m.salem2020@outlook.com"
}

variable "name" {
  type        = string
  description = "my name"
  default     = "ahmedsalem"
}

