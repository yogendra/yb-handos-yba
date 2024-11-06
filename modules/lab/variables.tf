

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
  default = []
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
  default = "10.0.0.0/24"
}

variable "region" {
  type = string
  description = "Region"
}
variable "zone" {
  type = string
  description = "Zone"
}
variable "ybalic" {
  type = string
  description = "YBA license"
}
variable "certsdir" {
  type = string
  description = "Location of cert DIR containing ca.key, ca.crt server.crt and server.key"
}

variable "yba-version" {
  type = string
  description = "YBA Version"
  default = "2024.1.3.0-b105"
}

variable "db-node-count" {
  type = number
  description = "No of DB Nodes to provision"
  default = 8
}
