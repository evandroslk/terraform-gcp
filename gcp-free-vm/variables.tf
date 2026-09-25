variable "project_id" {
  description = "ID do projeto GCP"
  type = string
  default = "evandro-project"
}

variable "region" {
  description = "Região da VM"
  type = string
  default = "us-central1"
}

variable "zone" {
  description = "Zona da VM"
  type = string
  default = "us-central1-a"
}