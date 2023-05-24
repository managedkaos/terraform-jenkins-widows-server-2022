
variable "server_count" {
  type        = number
  default     = 1
  description = "The total number of VMs to create"
}

variable "name" {
  type        = string
  description = "The name to assign to resources in this module"
  default     = "jenkins"
}

variable "environment" {
  type        = string
  description = "The environment to assign to resource in this module"
  default     = "windows"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags to asscociate to taggable resources in this module"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "root_volume_size" {
  type    = string
  default = 50
}

variable "production" {
  type    = bool
  default = false
}

locals {
  host = { for i in range(var.server_count) : join("-", [var.name, var.environment, i]) => {
    index = i
    name  = "${join("-", [var.name, var.environment, i])}"
    }
  }
}
