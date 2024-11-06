terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.5"
    }
  }
}
locals{
  prefix = var.name
  private-dns-zone = var.private_zone_id
  public-dns-zone = var.public_zone_id
  network-cidr = var.network-cidr
  subnet-cidr = cidrsubnet(var.network-cidr, 2,0)
  db-hostname-prefix = "db-"
  db-node-count = var.db-node-count
  project_id = data.google_project.project.project_id
  private-domain = data.google_dns_managed_zone.private-dns-zone.dns_name
  public-domain = data.google_dns_managed_zone.public-dns-zone.dns_name
  zone = var.zone
  region = var.region
  known-cidrs = var.known_cidrs
  ybadmin-authorized-keys = var.ybadmin-authorized-keys
  ybadmin-password = var.ybadmin-password
  yba-lic = var.ybalic
  ca-crt = file("${var.certsdir}/ca.crt")
  server-crt = file("${var.certsdir}/server.crt")
  server-key = file("${var.certsdir}/server.key")
  yba-version = var.yba-version
}
data "google_project" "project" {
}
data "google_dns_managed_zone" "private-dns-zone" {
  name = local.private-dns-zone
}
data "google_dns_managed_zone" "public-dns-zone" {
  name = local.public-dns-zone
}

// Create a network
//
