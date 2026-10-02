resource "google_certificate_manager_dns_authorization" "domain" {
  name = "regional-alb-dns-auth"
  location = var.region
  domain = var.domain
}

resource "google_certificate_manager_certificate" "domain" {
  name = "regional-alb-certificate"
  location = var.region

  managed {
    domains = [
        var.domain
    ]

    dns_authorizations = [
        google_certificate_manager_dns_authorization.domain.id
    ]
  }
}

### Registro CNAME que precisa ser criado no DNS para que o certificado seja emitido
output "dns_auth_record" {
  value = google_certificate_manager_dns_authorization.domain.dns_resource_record
}