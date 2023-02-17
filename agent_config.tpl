addresses = {
  dns = "127.0.0.54"
}

data_dir = "/var/consul"
datacenter = "{{ mustEnv "CONSUL_DATACENTER" }}"

acl {
  enabled = true
  tokens {
    default = "{{ mustEnv "AGENT_ACL_TOKEN" }}"
  }
}

dns_config = {
  cache_max_age = "86400s"
  node_ttl = "10s"
  only_passing = false
  service_ttl = {
    "*" = "10s"
  }

  soa = {
    expire = 43200
    min_ttl = 60
    refresh = 3600
  }

  use_cache = true
}

encrypt = "{{ mustEnv "CONSUL_ENCRYPTION_KEY" }}"
encrypt_verify_incoming = false
encrypt_verify_outgoing = false

leave_on_terminate = true
rejoin_after_leave = true

retry_join = {{ mustEnv "CONSUL_SERVERS" | split " " | toJSON }}
