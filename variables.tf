variable "name" {
  type = string
}

variable "description" {
  type = string

  default = "Managed by terraform"
}

variable "roles" {
  type = set(string)

  default = []
}

variable "folder_id" {
  type = string

  default = null
}

variable "static_access_key" {
  type = bool

  default = false
}

variable "service_account_key" {
  type = bool

  default = false
}
