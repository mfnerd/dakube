# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "host" {
  name                    = "host"
  project                 = google_project.host-staging-mundo.number
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1500
}
resource "google_compute_network" "service" {
  name                    = "service"
  project                 = google_project.k8s-staging-mundo.number
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1500
}
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  project                  = google_project.host-staging-mundo.number
  ip_cidr_range            = "10.187.69.0/24"
  region                   = local.region
  network                  = google_compute_network.host.self_link
  private_ip_google_access = true
}
resource "google_compute_subnetwork" "private2" {
  name                     = "private2"
  project                  = google_project.k8s-staging-mundo.number
  ip_cidr_range            = "10.187.70.0/24"
  region                   = local.region
  network                  = google_compute_network.service.self_link
  private_ip_google_access = true


  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = "10.187.71.0/24"
  }

  secondary_ip_range {
    range_name    = "services-ip-range"
    ip_cidr_range = "10.187.72.0/24"
  }
}
  # dynamic "secondary_ip_range" {
  #   for_each = local.secondary_ip_ranges

  #   content {
  #     range_name    = secondary_ip_range.key
  #     ip_cidr_range = secondary_ip_range.value
  #   }
  # }
