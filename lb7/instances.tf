### Instance Template

resource "google_compute_instance_template" "backend" {
  name_prefix = "regional-alb-backend-"
  machine_type = "e2-micro"

  tags = [
    "regional-alb-backend"
  ]

  disk {
    source_image = "debian-cloud/debian-12"
    disk_type = "pd-standard"
    disk_size_gb = 10
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab.id
  }

  metadata_startup_script = file("${path.module}/startup.sh")

}

### Managed Instance Group

resource "google_compute_region_instance_group_manager" "backend" {
  name = "regional-alb-backend-mig"

  region = var.region

  base_instance_name = "backend"

  version {
    instance_template = google_compute_instance_template.backend.id
  }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }

  distribution_policy_zones = [
    "${var.region}-a",
    "${var.region}-b"
  ]
}