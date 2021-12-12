variable "name" {
  description = "Name of the service account"

  type = string
}

variable "description" {
  description = "Description of the service account."

  type = string

  default = "Managed by terraform"
}

variable "folder_id" {
  description = "ID of the folder that the service account will be created in. Defaults to the provider folder configuration."

  type = string

  default = null
}

variable "roles" {
  description = "Roles of the service account in the folder."

  type = set(string)

  default = []
}

variable "static_access_key" {
  description = "Whether to create [service account static access key](https://cloud.yandex.com/docs/iam/operations/sa/create-access-key)."

  type = bool

  default = false
}

variable "service_account_key" {
  description = "Whether to create [service account authorized key](https://cloud.yandex.com/docs/iam/concepts/authorization/key)."

  type = bool

  default = false
}
