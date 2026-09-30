resource "google_bigquery_dataset" "analytics" {
  dataset_id = "fitjourney_analytics"
  location = "US"
}

resource "google_bigquery_table" "spanner_export" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id = "spanner_customers"

  schema = jsonencode([
    {
      name = "customer_id"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "name"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "subscription_status"
      type = "STRING"
      mode = "NULLABLE"
    }
  ])

  external_data_configuration {
    autodetect = false
    source_format = "CSV"
    
    csv_options {
      skip_leading_rows = 1
      quote = "\""
    }

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