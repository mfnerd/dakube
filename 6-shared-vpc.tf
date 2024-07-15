# /* # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_host_project
# resource "google_compute_shared_vpc_host_project" "host" {
#   project = google_project.host-staging-mundo.number
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project
# resource "google_compute_shared_vpc_service_project" "service" {
#   host_project    = local.host_project_id
#   service_project = local.service_project_id

#   depends_on = [google_compute_shared_vpc_host_project.host]
# } */
#create network peering
resource "google_compute_network_peering" "hostproject" {
  name         = "hostproject"
  network      = google_compute_network.host.self_link
  peer_network = google_compute_network.service.self_link

}
resource "google_compute_network_peering" "serviceproject" {
  name         = "serviceproject"
  network      = google_compute_network.service.self_link
  peer_network = google_compute_network.host.self_link
 
}
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork_iam
resource "google_compute_subnetwork_iam_binding" "binding" {
  project    = google_project.host-staging-mundo.number
  region     = google_compute_subnetwork.private.region
  subnetwork = google_compute_subnetwork.private.name

  role = "roles/compute.networkUser"
  members = [
    "serviceAccount:${google_service_account.k8s-staging-mundo.email}",
    "serviceAccount:${google_project.k8s-staging-mundo.number}@cloudservices.gserviceaccount.com",
    "serviceAccount:service-${google_project.k8s-staging-mundo.number}@container-engine-robot.iam.gserviceaccount.com"
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_binding" "container-engine" {
  project = google_project.host-staging-mundo.number
  role    = "roles/container.hostServiceAgentUser"

  members = [
    "serviceAccount:service-${google_project.k8s-staging-mundo.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
  depends_on = [google_project_service.service]
}