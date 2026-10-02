variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região onde o lab será criado"
  type        = string
  default     = "us-central1"
}

variable "domain" {
  description = "Domínio que será apontado para o IP do Load Balancer"
  type        = string
}

variable "is_application_lb" {
  type = bool
  default = false
}

variable "is_proxy_lb" {
  type = bool
  default = false
}

variable "is_passthrough_lb" {
  type = bool
  default = false
}