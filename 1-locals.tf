locals {
  region               = "us-central1"

  billing_account      = "01BC59-B68A3A-F01316"
  host_project_name    = "host-staging-mundo"
  service_project_name = "k8s-staging-mundo"
  host_project_id      = "${local.host_project_name}-${random_integer.int.result}"
  service_project_id   = "${local.service_project_name}-${random_integer.int.result}"
  projects_api         = "container.googleapis.com"
  secondary_ip_ranges = {
    "pod-ip-range"      = "10.187.71.0/24",
    "services-ip-range" = "10.187.72.0/24"
  }
}
