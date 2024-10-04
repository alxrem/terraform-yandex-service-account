# Copyright 2021-2024 Alexey Remizov <alexey@remizov.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

variable "static_access_keys" {
  description = <<DESCRIPTION
  [Static access keys](https://cloud.yandex.com/docs/iam/operations/sa/create-access-key) of account.

  Map from the symbolic name to properties of the keys.
  DESCRIPTION

  type = map(object({
    description = optional(string, "Managed by Terraform")
    pgp_key     = optional(string)

    output_to_lockbox = optional(object({
      secret_id            = string
      entry_for_access_key = string
      entry_for_secret_key = string
    }))
  }))

  default = {}
}

variable "service_account_keys" {
  description = <<DESCRIPTION
  [Authorized keys](https://cloud.yandex.com/docs/iam/concepts/authorization/key) of account.

  Map from the symbolic name to properties of the keys.
  DESCRIPTION

  type = map(object({
    description   = optional(string, "Managed by Terraform")
    format        = optional(string)
    key_algorithm = optional(string)
    pgp_key       = optional(string)

    output_to_lockbox = optional(object({
      secret_id             = string
      entry_for_private_key = string
    }))
  }))

  default = {}
}
