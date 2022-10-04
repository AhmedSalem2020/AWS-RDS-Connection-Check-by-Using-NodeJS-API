variable "repo_name" {
type        = string
description = "The name of the CodeCommit repository (e.g. new-repo)."
default     = "ahmedsalem_Repo"
}

variable "repo_branch" {
  type        =  string
  description = "The name of the default repository branch (default: master)"
  default     = "main"
}

variable "app_name" {
  default = "HelloWorld_App"
}

variable "bucket_name" {
  default= "ahmedsalem-demobucket"
}