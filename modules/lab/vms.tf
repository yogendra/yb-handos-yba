
data "cloudinit_config" "jumpbox" {
  gzip          = false
  base64_encode = false
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${path.module}/jumpbox-cloud-init.tftpl",{
      ybadmin-authorized-keys = local.ybadmin-authorized-keys
      ybadmin-password = local.ybadmin-password
    })
  }
}
resource "google_compute_instance" "jumpbox" {
  name         = "${local.prefix}-jumpbox"
  machine_type = "e2-medium"
  zone         = local.zone
#

  boot_disk {
    initialize_params {
      image = "almalinux-cloud/almalinux-8"
      size  = 100
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.name
    network_ip = cidrhost(local.subnet-cidr, 5)
    access_config {
    }
  }

  tags = ["bastion-host"]

  metadata = {
    user-data = data.cloudinit_config.jumpbox.rendered
  }

#  service_account {
#     # No access to APIs
#     scopes = []
#   }
}

data "cloudinit_config" "yba" {
  gzip          = false
  base64_encode = false
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${path.module}/yba-cloud-init.tftpl",{
      ybadmin-authorized-keys = local.ybadmin-authorized-keys
      ybadmin-password = local.ybadmin-password
    })
  }
}
resource "google_compute_instance" "yba" {
  name         = "${local.prefix}-yba"
  machine_type = "e2-medium"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "almalinux-cloud/almalinux-8"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.name
    network_ip = cidrhost(local.subnet-cidr, 6)
  }

  attached_disk {
    source = google_compute_disk.yba_data_disk.self_link
    mode   = "READ_WRITE"
  }

  metadata = {
    user-data = data.cloudinit_config.yba.rendered
  }
  # service_account {
  #   # No access to APIs
  #   scopes = []
  # }

}

resource "google_compute_disk" "yba_data_disk" {
  name  = "${local.prefix}-yba-data-disk"
  type  = "pd-standard"
  size  = 200
  zone  = local.zone
  project = local.project_id
}


data "cloudinit_config" "db" {
  gzip          = false
  base64_encode = false
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${path.module}/db-cloud-init.tftpl",{
      ybadmin-authorized-keys = local.ybadmin-authorized-keys
      ybadmin-password = local.ybadmin-password
    })
  }
}

resource "google_compute_instance" "db" {
  count        = local.db-node-count
  name         = "${local.prefix}-db-${count.index + 1}"
  machine_type = "e2-small"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "almalinux-cloud/almalinux-8"
      size  = 50
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.name
    network_ip = cidrhost(local.subnet-cidr, count.index + 11)
  }

  attached_disk {
    source = google_compute_disk.db_data_disk[count.index].self_link
    mode   = "READ_WRITE"

  }
  # service_account {
  #   # No access to APIs
  #   scopes = []
  # }


  metadata = {
    user-data = data.cloudinit_config.db.rendered
  }
}




resource "google_compute_disk" "db_data_disk" {
  count = local.db-node-count
  name  = "${local.prefix}-db-${count.index + 1}-data-disk"
  type  = "pd-standard"
  size  = 50
  zone  = local.zone
  project = local.project_id
}
