resource "google_storage_bucket" "lab_bucket" {
  name = "${var.project_id}-lab-bucket"
  location = "US"
  uniform_bucket_level_access = true

  force_destroy = true
}

resource "google_storage_bucket_object" "test_file" {
  name = "teste.txt"
  bucket = google_storage_bucket.lab_bucket.name
  content = <<-EOF
    Arquivo criado pelo Terraform.
  EOF
}