resource "google_compute_network" "lab" {
  name = "regional-alb-lab-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lab" {
  name = "regional-alb-lab-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region = var.region
  network = google_compute_network.lab.id
}

### Proxy-only-subnet exigida para o funcionamento do ALB regional externo
resource "google_compute_subnetwork" "proxy_only" {
  name = "regional-alb-lab-proxy-only"
  ip_cidr_range = "10.129.0.0/23"
  region = var.region
  network = google_compute_network.lab.id
  purpose = "REGIONAL_MANAGED_PROXY"
  role = "ACTIVE"
}

resource "google_compute_firewall" "allow_health_checks" {
  name = "regional-alb-lab-allow-health-checks"
  network = google_compute_network.lab.name

  direction = "INGRESS"

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  target_tags = ["regional-alb-backend"]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name = "allow-iap-ssh"
  network = google_compute_network.lab.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]

  target_tags = ["regional-alb-backend"]
}

resource "google_compute_firewall" "allow_proxy_only" {
  name = "regional-alb-lab-allow-proxy-only"
  network = google_compute_network.lab.name
  direction = "INGRESS"
  source_ranges = ["10.129.0.0/23"]
  target_tags = ["regional-alb-backend"]

  allow {
    protocol = "tcp"
    ports = ["80"]
  }
}

resource "google_compute_router" "lab" {
  name = "regional-alb-lab-router"
  region = var.region
  network = google_compute_network.lab.id
}

resource "google_compute_router_nat" "lab" {
  name = "regional-alb-lab-nat"
  router = google_compute_router.lab.name
  region = var.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}