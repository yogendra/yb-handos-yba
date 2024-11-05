

variable "name" {
  type = string
  description = "Name of the lab environment"
}

variable "private_zone_id" {
  type = string
  description = "ID of the private Cloud DNS zone"
}


variable "public_zone_id" {
  type = string
  description = "ID of the public Cloud DNS zone"
}

variable "known_cidrs" {
  type = list(string)
  description = "List of know CIDRs"
}
variable "ybadmin-password" {
  type = string
  description = "Password for ybadmin"
}

variable "ybadmin-authorized-keys" {
  type = list(string)
  description = "Authorized keys for ybadmin"
}

variable "network-cidr" {
  type = string
  description = "Network CIDR for lab"
}

variable "region" {
  type = string
  description = "Region"
}
variable "zone" {
  type = string
  description = "Zone"
}
