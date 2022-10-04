variable "VpcCIDR" {
  type        = string
  description = "Please enter the IP range (CIDR notation) for this VPC"
  default     = "10.40.0.0/16"
}

variable "PublicSubnet1CIDR" {
  type        = string
  description = "Please enter the IP range (CIDR notation) for the public subnet in the AZ A"
  default     = "10.40.1.0/24"
}

variable "PublicSubnet2CIDR" {
  type        = string
  description = "Please enter the IP range (CIDR notation) for the public subnet in the second AZ B"
  default     = "10.40.2.0/24"
}

variable "PrivateSubnet1CIDR" {
  type        = string
  description = "Please enter the IP range (CIDR notation) for the private subnet in the first AZ A"
  default     = "10.40.10.0/24"
}

variable "PrivateSubnet2CIDR" {
  type        = string
  description = "Please enter the IP range (CIDR notation) for the private subnet in the second AZ B"
  default     = "10.40.20.0/24"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
  default     = [ "us-east-2a", "us-east-2b" ]
}

variable "name" {
  type        = string
  description = "my name"
  default     = "ahmedsalem"
}

variable "mail" {
  type        = string
  description = "username"
  default     = "ahmed.m.salem2020@outlook.com"
}
