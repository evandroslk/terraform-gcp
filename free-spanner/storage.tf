resource "google_storage_bucket" "spanner_exports" {
  name = "${var.project_id}-spanner-exports"
  location = "US"

  uniform_bucket_level_access = true

  force_destroy = true
}

resource "google_storage_bucket_object" "customers_csv" {
  name = "customers.csv"
  bucket = google_storage_bucket.spanner_exports.name
  source = "${path.module}/app-exemplo/customers.csv"
}