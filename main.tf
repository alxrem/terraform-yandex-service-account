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

data "yandex_client_config" "default" {}

locals {
  folder_id = coalesce(var.folder_id, data.yandex_client_config.default.folder_id)
}

resource "yandex_iam_service_account" "default" {
  name        = var.name
  description = var.description
  folder_id   = local.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "default" {
  for_each = var.roles

  folder_id = local.folder_id
  member    = "serviceAccount:${yandex_iam_service_account.default.id}"
  role      = each.value
}

resource "yandex_iam_service_account_static_access_key" "default" {
  for_each = var.static_access_keys

  service_account_id = yandex_iam_service_account.default.id

  description = each.value.description
  pgp_key     = each.value.pgp_key

  dynamic "output_to_lockbox" {
    for_each = each.value.output_to_lockbox[*]

    content {
      secret_id            = output_to_lockbox.value["secret_id"]
      entry_for_access_key = output_to_lockbox.value["entry_for_access_key"]
      entry_for_secret_key = output_to_lockbox.value["entry_for_secret_key"]
    }
  }
}

resource "yandex_iam_service_account_key" "default" {
  for_each = var.service_account_keys

  service_account_id = yandex_iam_service_account.default.id

  description   = each.value.description
  format        = each.value.format
  key_algorithm = each.value.key_algorithm
  pgp_key       = each.value.pgp_key

  dynamic "output_to_lockbox" {
    for_each = each.value.output_to_lockbox[*]

    content {
      secret_id             = output_to_lockbox.value["secret_id"]
      entry_for_private_key = output_to_lockbox.value["entry_for_private_key"]
    }
  }
}

locals {
  service_account_keys = {
    for name, key in yandex_iam_service_account_key.default : name => merge(
      key,
      {
        json_key = jsonencode({
          created_at         = key.created_at
          id                 = key.id
          key_algorithm      = key.key_algorithm
          private_key        = key.private_key
          public_key         = key.public_key
          service_account_id = key.service_account_id
        })
      }
    )
  }
}
