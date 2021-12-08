resource "yandex_iam_service_account" "default" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
}

data "yandex_client_config" "config" {}

resource "yandex_resourcemanager_folder_iam_member" "default" {
  for_each = var.roles

  folder_id = coalesce(var.folder_id, data.yandex_client_config.config.folder_id)
  member    = "serviceAccount:${yandex_iam_service_account.default.id}"
  role      = each.value
}

resource "yandex_iam_service_account_static_access_key" "default" {
  count = var.static_access_key ? 1 : 0

  service_account_id = yandex_iam_service_account.default.id

  description = "Managed by terraform"
}

resource "yandex_iam_service_account_key" "default" {
  count = var.service_account_key ? 1 : 0

  service_account_id = yandex_iam_service_account.default.id

  description = "Managed by terraform"
}
