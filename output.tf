output "id" {
  value = yandex_iam_service_account.default.id
}

output "access_key" {
  value = try(yandex_iam_service_account_static_access_key.default[0].access_key, null)
}

output "secret_key" {
  value = try(yandex_iam_service_account_static_access_key.default[0].secret_key, null)

  sensitive = true
}

output "service_account_key" {
  value = try(jsonencode({
    created_at         = yandex_iam_service_account_key.default[0].created_at
    id                 = yandex_iam_service_account_key.default[0].id
    key_algorithm      = yandex_iam_service_account_key.default[0].key_algorithm
    private_key        = yandex_iam_service_account_key.default[0].private_key
    public_key         = yandex_iam_service_account_key.default[0].public_key
    service_account_id = yandex_iam_service_account_key.default[0].service_account_id
  }), null)

  sensitive = true
}
