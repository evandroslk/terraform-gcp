resource "google_service_account" "bucket_reader" {
  account_id = "bucket-reader"
  display_name = "Bucket Reader"
}

resource "google_storage_bucket_iam_member" "bucket_reader" {
  bucket = google_storage_bucket.lab_bucket.name
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.bucket_reader.email}"
}

// Custom Role
resource "google_project_iam_custom_role" "compute_inventory_viewer" {
  project = var.project_id
  role_id = "computeInventoryViewer"
  title = "Compute Inventory Viewer"
  description = "Allows listing Compute Engine disks and images only"

  permissions = [
    "compute.disks.list",
    "compute.images.list"
  ]
}

# resource "google_project_iam_member" "sa_compute_inventory" {
#   project = var.project_id
#   role = google_project_iam_custom_role.compute_inventory_viewer.name
#   member = "serviceAccount:${google_service_account.bucket_reader.email}"
# }