terraform {

}

module "base-infra" {
  source = "modules/base-infra"
  name = "base-infra"
}

locals {
  allow-cidrs = [
    "${data.http.self-ip.response_body}/32",
    "52.76.7.167/32"
  ]
  password="Password#123"
}
module "lab01"{
  source = "modules/lab"
  name = "lab01"
  allow-cidrs = local.allow-cidrs
  password=local.password
}

data "http" "self" {
  url = "https://ifconfig.me"
}


