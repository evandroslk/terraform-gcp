### Health Check

resource "google_compute_region_health_check" "backend" {
  count = var.is_application_lb ? 1 : 0
  name = "regional-alb-backend-health-check"
  region = var.region

  http_health_check {
    port = 80
    request_path = "/"
  }
}

### Backend Service

resource "google_compute_region_backend_service" "backend" {
  count = var.is_application_lb ? 1 : 0
  name = "regional-alb-backend-service"
  region = var.region

  protocol = "HTTP"

  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [
    google_compute_region_health_check.backend[0].id
  ]

  backend {
    group = google_compute_region_instance_group_manager.backend.instance_group
    capacity_scaler = 1.0
  }
}

### URL map

resource "google_compute_region_url_map" "default" {
  count = var.is_application_lb ? 1 : 0
  name = "regional-alb-url-map"
  region = var.region

  default_service = google_compute_region_backend_service.backend[0].id
  
}

### Target HTTPS Proxy

resource "google_compute_region_target_https_proxy" "https" {
  count = var.is_application_lb ? 1 : 0
  name = "regional-alb-https-proxy"
  region = var.region

  url_map = google_compute_region_url_map.default[0].id

  certificate_manager_certificates = [
    google_certificate_manager_certificate.domain.id
  ]
}

### IP Público

resource "google_compute_address" "lb" {
  count = var.is_application_lb ? 1 : 0
  name = "regional-alb-ip"
  region = var.region
}

### Forwarding Rule

resource "google_compute_forwarding_rule" "https" {
  count = var.is_application_lb ? 1 : 0
  name = "regional-alb-https-forwarding-rule"
  region = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target = google_compute_region_target_https_proxy.https[0].id
  port_range = "443"
  ip_address = google_compute_address.lb[0].id
  network = google_compute_network.lab.id
  depends_on = [ google_compute_subnetwork.proxy_only ]
}

### Listener HTTP Temporário para Teste

resource "google_compute_region_target_http_proxy" "http" {
  count = 0
  name = "regional-alb-http-proxy"
  region = var.region
  url_map = google_compute_region_url_map.default[0].id
}

resource "google_compute_forwarding_rule" "http" {
  count = 0
  name = "regional-alb-http-forwarding-rule"
  region = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target = google_compute_region_target_http_proxy.http[0].id
  port_range = "80"
  ip_address = google_compute_address.lb[0].id
  network = google_compute_network.lab.id
  depends_on = [ google_compute_subnetwork.proxy_only ]
}