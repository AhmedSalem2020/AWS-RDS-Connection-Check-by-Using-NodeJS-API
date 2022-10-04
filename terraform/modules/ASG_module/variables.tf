variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones (e.g. `['us-east-2a', 'us-east-2b']`)"
  default     = [ "us-east-2a", "us-east-2b" ]
}

variable "image_id" {
  type    = string
  default = "ami-0f924dc71d44d23e2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "keyPair" {
  default = "salemmm"
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

variable "PrivateWebServerSecurityGroup" {
  type = list
}

variable "health_check_type" {
  default = "ELB"
}

variable "target_group" {
  type = string
}

variable "private_subnet1" {
  type = string
}

variable "private_subnet2" {
  type = string
}

variable "my_secret" {
  type = string
}