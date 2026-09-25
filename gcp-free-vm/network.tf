### VPC

resource "google_compute_network" "free_vpc" {
  name = "free-vpc"
  auto_create_subnetworks = false
}

### Subnet

resource "google_compute_subnetwork" "free_subnet" {
  name = "free-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region = var.region
  network = google_compute_network.free_vpc.id
  private_ip_google_access = true
}

### Firewall - SSH via IAP (Identity-Aware Proxy)

resource "google_compute_firewall" "allow_iap_ssh" {
  name = "allow-iap-ssh"
  network = google_compute_network.free_vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}