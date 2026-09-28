resource "google_bigquery_dataset" "analytics" {
  dataset_id = "fitjourney_analytics"
  location = "US"
}

resource "google_bigquery_table" "spanner_export" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id = "spanner_customers"

  external_data_configuration {
    autodetect = true
    source_format = "CSV"

    source_uris = [
        "${google_storage_bucket.spanner_exports.url}/customers.csv"
    ]
  }
}

resource "google_bigquery_table" "bigtable_activity" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id = "bigtable_activity"

  external_data_configuration {
    source_format = "BIGTABLE"

    source_uris = [
        "https://googleapis.com/bigtable/${google_bigtable_table.activity.id}"
    ]

    autodetect = true
  }
}