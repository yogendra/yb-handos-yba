VAULT_INIT_JSON=/vault/data/init.json
VAULT_YBA_TOKEN=/vault/data/yba-token.json
chown -R vault:vault data
vault server -config /vault/config/vault.conf 2>1 | tee -a /vault/logs/start-vault.log &
vault_pid=$!
echo PID: $vault_pid
echo Sleepign for 2s
sleep 2
echo Woke up
if [[ ! -f $VAULT_INIT_JSON ]]; then
  echo Initing
  vault operator init -key-shares=1 -key-threshold=1 -format=json > $VAULT_INIT_JSON
fi
echo Load init data
VAULT_UNSEAL_KEY=$(cat $VAULT_INIT_JSON | jq -r '.unseal_keys_b64[0]')
VAULT_TOKEN=$(cat $VAULT_INIT_JSON | jq -r '.root_token')
echo VUK: $VAULT_UNSEAL_KEY VT: $VAULT_TOKEN
echo Unseal

vault operator unseal "$VAULT_UNSEAL_KEY"
vault login -no-print $VAULT_TOKEN
if [[ ! -f  /vault/data/yba-token.json ]]; then
  echo Init Setup - login
  vault auth enable userpass
  vault write auth/userpass/users/admin password="Password#123"
  echo Init Setup - transit
  vault secrets enable transit
  echo Init Setup - YBA Policy
  vault policy write yba /vault/config/yba.hcl
  echo Init Setup - YBA Token
  vault token create -no-default-policy -policy=yba --period=32d --format=json > $VAULT_YBA_TOKEN
fi
kill $vault_pid
echo Ready
vault server -config /vault/config/vault.conf
