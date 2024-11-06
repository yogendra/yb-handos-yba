terraform {

}
module "test" {
  source = "../"
  name = "tl01"
  known_cidrs = [
    "${data.http.self-ip.response_body}/32",
    "35.235.240.0/20"
  ]
  network-cidr = "10.0.0.0/24"
  private_zone_id = "yblab"
  public_zone_id = "ws-apj-yugabyte-com"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
  ybadmin-authorized-keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKeXZBhdy+glGDa8WTHaGR7dx5iPVXp69Zh6QKJw3kk8z18T/MLYPO86fF6uLCuVWoP8umblGj6umdBgNLt7rRUbYthB8nbcXD/t5SrqrwABIHg8DoMIp22zz1ouwh5m418kmARjR+hDrhyhk435LAYSGFVWVQEwYjBCsy0ZFDSQz1iOkqkul4j8YURAWqwNS6ywLHS4ax6DkjuJIakb7g1x/ApUdu1Rdb1TL3Zr8wpj3U7NbLM+6TW3/RRcuU5cDJZnRzSCf3I3b0yXiAcJXMLlO9l8VMl0X2QJh7QXzT3cHvYw93C+MVvymnQCNTul9DGNisqMxsRco4iV21qC8d yrampuria@yrampuria-workstation"
   ]
   ybadmin-password = "testp@ss"
   certsdir = "../../../private/certs"
   ybalic= file("../../../private/yba.lic")
}

data "http" "self-ip"{
  url = "https://ifconfig.me"
}



provider "google" {
  project = "apj-partner-enablement"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
}
output "info" {
  value = module.test.info-html
}

output "name" {
  value = module.test.name
}
