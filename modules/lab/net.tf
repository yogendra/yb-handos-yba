resource "google_compute_network" "main" {
  name                    = "${local.prefix}-network"
  auto_create_subnetworks = false
  mtu                     = 1460
  project                 = local.project_id
}

resource "google_compute_subnetwork" "main" {
  name          = "${local.prefix}-subnet"
  ip_cidr_range = local.subnet-cidr
  region        = local.region
  network       = google_compute_network.main.name
 project       = local.project_id
}

resource "google_compute_firewall" "allow-ssh-to-bastion" {
  name    = "${local.prefix}-allow-ssh-to-bastion"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = local.known-cidrs
  target_tags   = ["bastion-host"]
}

# DNS Records

resource "google_dns_record_set" "jumpbox_private" {
  name    = "jumpbox.${local.prefix}.${local.private-domain}"
  type    = "A"
  ttl     = 300
  managed_zone = local.private-dns-zone
  rrdatas = [google_compute_instance.jumpbox.network_interface.0.network_ip]
}

resource "google_dns_record_set" "jumpbox_public" {
  name    = "jumpbox-${local.prefix}.${local.public-domain}"
  type    = "A"
  ttl     = 300
  managed_zone = local.public-dns-zone
  rrdatas = [google_compute_instance.jumpbox.network_interface.0.access_config.0.nat_ip]
}

resource "google_dns_record_set" "yba_private" {
  name    = "yba.${local.prefix}.${local.private-domain}"
  type    = "A"
  ttl     = 300
  managed_zone = local.private-dns-zone
  rrdatas = [google_compute_instance.yba.network_interface.0.network_ip]
}

resource "google_dns_record_set" "db_private" {
  count        = local.db-node-count
  name         = "db${count.index + 1}.${local.prefix}.${local.private-domain}"
  type         = "A"
  ttl          = 300
  managed_zone = local.private-dns-zone
  rrdatas = [google_compute_instance.db[count.index].network_interface.0.network_ip]
}
