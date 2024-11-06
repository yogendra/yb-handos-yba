
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

  tags = ["iapssh", "jumpbox"]

  metadata = {
    startup-script = templatefile("${path.module}/jumpbox-init.tftpl",{
      ybadmin-authorized-keys = local.ybadmin-authorized-keys
      ybadmin-password = local.ybadmin-password
      ca-crt = local.ca-crt
      server-crt = local.server-crt
      server-key = local.server-key
    })
  }

 service_account {
    # No access to APIs
    scopes = []
  }
}


resource "google_compute_instance" "yba" {
  name         = "${local.prefix}-yba"
  machine_type = "e2-medium"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "almalinux-cloud/almalinux-8"
      size  = 300
    }
  }
  tags = ["iapssh", "yba"]
  network_interface {
    subnetwork = google_compute_subnetwork.main.name
    network_ip = cidrhost(local.subnet-cidr, 10)
  }


  metadata = {
     startup-script = templatefile("${path.module}/yba-init.tftpl",{
      ybadmin-authorized-keys = local.ybadmin-authorized-keys
      ybadmin-password = local.ybadmin-password
      ca-crt = local.ca-crt
      server-crt = local.server-crt
      server-key = local.server-key
      yba-lic = local.yba-lic
      yba-version = local.yba-version
    })
  }
  service_account {
    # No access to APIs
    scopes = []
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
      size  = 120
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.name
    network_ip = cidrhost(local.subnet-cidr, count.index + 11)
  }
  tags = ["iapssh", "db"]

  service_account {
    # No access to APIs
    scopes = []
  }


  metadata = {
     startup-script = templatefile("${path.module}/db-init.tftpl",{
      ybadmin-authorized-keys = local.ybadmin-authorized-keys
      ybadmin-password = local.ybadmin-password
      ca-crt = local.ca-crt
      server-crt = local.server-crt
      server-key = local.server-key
    })
  }
}
