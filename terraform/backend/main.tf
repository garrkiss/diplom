resource "yandex_storage_bucket" "terraform_state" {
  bucket     = "tf-state-bucket-${var.folder_id}"
  acl        = "private"
  access_key = yandex_iam_service_account_static_access_key.sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_key.secret_key
}

resource "yandex_iam_service_account" "sa" {
  name = "terra2"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}

resource "yandex_iam_service_account_static_access_key" "sa_key" {
  service_account_id = yandex_iam_service_account.sa.id
}
