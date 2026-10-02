resource "google_bigtable_instance" "teste_bigtable" {
  name = "teste-bigtable"
  display_name = "teste-bigtable"

  cluster {
    cluster_id = "teste-bigtable-c1"
    zone = "us-central1-a"
    storage_type = "SSD"
  }

  lifecycle {
    ignore_changes = [ deletion_protection, instance_type ]
    prevent_destroy = true
  }
}

resource "google_bigtable_table" "activity" {
  name = "customer_activity"
  instance_name = google_bigtable_instance.teste_bigtable.name

  column_family {
    family = "events"
  }
}

output "activity_bigtable_name" {
  value = google_bigtable_table.activity.id
}