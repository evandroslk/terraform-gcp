resource "google_compute_instance" "free_vm" {
  name = "free-vm"
  machine_type = "e2-micro"
  zone = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size = 20
      type = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.free_subnet.id
    
    # Sem access_config = sem IP externo
  }

  service_account {
    email = google_service_account.bucket_reader.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
