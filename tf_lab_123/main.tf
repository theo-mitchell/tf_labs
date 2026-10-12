terraform {
  required_version = "~> 1.16"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "base" {
  filename = "${path.module}/hello.txt"
  content  = "day 1-3 lab"
}


data "local_file" "readback" {
  filename = local_file.base.filename
}

resource "local_file" "derived" {
  filename = "${path.module}/derived.txt"
  content  = "base says: ${data.local_file.readback.content} (${length(data.local_file.readback.content)} chars)"
}


variable "filename" {
  type    = string
  default = "hello.txt"
}

variable "message" {
  type    = string
  default = "day 1-3 lab"
}

variable "ttl" {
  type    = number
  default = 3600
  validation {
    condition     = var.ttl > 0 && var.ttl <= 86400
    error_message = "ttl must be between 1 and 86400 seconds."
  }
}

output "base_file" {
  value = local_file.base.filename
}

output "derived_preview" {
  value = local_file.derived.content
}
