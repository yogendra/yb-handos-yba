resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "local_file" "ca-private-key" {
  content  = tls_private_key.ca.private_key_pem
  filename = "${path.root}/private/certs/ca.key"
}
resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  is_ca_certificate = true

  subject {
    country             = "SG"
    province            = "Singapore"
    locality            = "Signapore"
    common_name         = "YugabyteDB HOL CA"
    organization        = "YBHOL"
    organizational_unit = "YBHOL"
  }

  validity_period_hours = 43800 //  1825 days or 5 years

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

resource "local_file" "ca-cert" {
  content  = tls_self_signed_cert.ca.cert_pem
  filename = "${path.root}/private/certs/ca.crt"
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "local_file" "server-private-key" {
  content  = tls_private_key.server.private_key_pem
  filename = "${path.root}/private/certs/server.key"
}

resource "tls_cert_request" "server" {

  private_key_pem = tls_private_key.server.private_key_pem

  dns_names = ["*.yblab", "yblab", "ws.apj.yugabyte.com", "*.ws.apj.yugabyte.com" ]

  subject {
    country             = "SG"
    province            = "Singapore"
    locality            = "Singaport"
    common_name         = "YugabtyeDB HOL"
    organization        = "YBHOL"
    organizational_unit = "YBHOL"
  }
}

resource "tls_locally_signed_cert" "server" {
  // CSR by the development servers
  cert_request_pem = tls_cert_request.server.cert_request_pem
  // CA Private key
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  // CA certificate
  ca_cert_pem = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 43800

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

resource "local_file" "server-cert" {
  content  = tls_locally_signed_cert.server.cert_pem
  filename = "${path.root}/private/certs/server.crt"
}
