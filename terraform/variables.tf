variable "location"{
  default  = "France Central"
  type     = string
  nullable = false
}

variable "environment" {
  default  = "dev"
  type     = string
  nullable = false
  validation {
    condition = contains(["dev", "stage", "prod"], var.environment)
    error_message = "dev, stage, prod only !"
  }
}

variable "cluster_name" {
  default = "data-platform"
  type = string
  nullable = false
}

variable "cluster_version" {
  default = "1.29"
  type = string
  nullable = false
}