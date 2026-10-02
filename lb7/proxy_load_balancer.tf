### Health Check

resource "google_compute_region_health_check" "tcp" {
  count = var.is_proxy_lb ? 1 : 0
  name = "internal-proxy-lb-health-check"
  region = var.region

  tcp_health_check {
    port = 80
  }
}

### Backend Service

resource "google_compute_region_backend_service" "backend_proxy" {
  count = var.is_proxy_lb ? 1 : 0
  name = "internal-proxy-lb-backend"
  region = var.region

  protocol = "TCP"

  load_balancing_scheme = "INTERNAL_MANAGED"

  health_checks = [
    google_compute_region_health_check.tcp[0].id
  ]

  backend {
    group = google_compute_region_instance_group_manager.backend.instance_group
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_target_tcp_proxy" "tcp" {
  count = var.is_proxy_lb ? 1 : 0
  name = "internal-proxy-lb-tcp-proxy"
  region = var.region
  backend_service = google_compute_region_backend_service.backend_proxy[0].id
}

resource "google_compute_forwarding_rule" "internal" {
  count = var.is_proxy_lb ? 1 : 0
  name = "internal-proxy-lb-forwarding-rule"
  region = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"

  ip_protocol = "TCP"
  port_range = "80"

  network = google_compute_network.lab.id
  subnetwork = google_compute_subnetwork.lab.id

  target = google_compute_region_target_tcp_proxy.tcp[0].id
  depends_on = [ google_compute_subnetwork.proxy_only ]
}