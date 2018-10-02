resource "google_compute_network" "qlik_vpc" {
  name                    = "qlik-sense-vpc"
  description             = "VPC for Qlik deployment"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "qlik_subnet" {
  name                     = "qlik-sense-subnet"
  description              = "Subnet for Qlik Sense Enterprise"
  region                   = "${var.region}"
  ip_cidr_range            = "${var.network_cidr}"
  network                  = "${google_compute_network.qlik_vpc.self_link}"
  private_ip_google_access = true
}

resource "google_compute_firewall" "qs-qps-allow-ingress" {
  name        = "qs-qps-allow-ingress"
  description = "Allow HTTPS from any source to Qlik Proxy Service"
  network     = "${google_compute_network.qlik_vpc.name}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["${var.central_node_tag}"]
}
resource "google_compute_firewall" "winrm_allow_ingress" {
  name        = "winrm-allow-ingress"
  description = "Allow Win RM from any source"
  network     = "${google_compute_network.qlik_vpc.name}"

  allow {
    protocol = "tcp"
    ports    = ["5985"]
  }

  target_tags = ["${var.central_node_tag}"]
}
resource "google_compute_firewall" "qs-icmp-allow-ingress" {
  name        = "qs-icmp-allow-ingress"
  description = "Allow ICMP (ping) from any source"
  network     = "${google_compute_network.qlik_vpc.name}"

  allow {
    protocol = "icmp"
  }

  target_tags = ["${var.central_node_tag}"]
}
resource "google_compute_firewall" "qs-rdp-allow-ingress" {
  name        = "qs-rdp-allow-ingress"
  description = "Allow RDP access from any source"
  network     = "${google_compute_network.qlik_vpc.name}"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags = ["${var.central_node_tag}"]
}
