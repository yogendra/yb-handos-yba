locals {
  vms-list = [ for vm in concat([google_compute_instance.jumpbox, google_compute_instance.yba], google_compute_instance.db[*]): {
    name = vm.name
    public_ip = length(vm.network_interface[0].access_config) == 1 ?  vm.network_interface[0].access_config[0].nat_ip  : ""
    private_ip =vm.network_interface[0].network_ip
    public_dns = ""
    private_dns = ""
    ssh-user = "ybadmin"
    ssh-password = local.ybadmin-password
    cpu = ""
    ram = ""
    os_disk = ""
  } ]

  info = {
    name = local.prefix
    jb-webtop = "https://${google_dns_record_set.jumpbox_public.name}:3001/"
    jb-user = "ybadmin"
    jb-password = local.ybadmin-password
    other = {

    }
    vms = local.vms-list
  }
}

output "info-html" {
  value = templatefile("${path.module}/info.html", local.info)
}
output "name" {
  value = local.prefix
}
