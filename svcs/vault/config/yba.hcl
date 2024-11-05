path "transit/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/lookup-self" {
        capabilities = ["read"]
}

path "sys/capabilities-self" {
        capabilities = ["read", "update"]
}

path "auth/token/renew-self" {
        capabilities = ["update"]
}

path "sys/*" {
        capabilities = ["read"]
}
