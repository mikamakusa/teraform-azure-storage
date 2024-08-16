## DATAS ##

variable "virtual_network_name" {
  type    = string
  default = null
}

variable "subnet_name" {
  type    = string
  default = null
}

## MODULES ##

variable "keyvault" {
  type    = any
  default = []
}

variable "keyvault_key" {
  type    = any
  default = []
}

## RESOURCES ##

variable "hpc_cache" {
  type = list(object({
    id                                         = number
    cache_size_in_gb                           = number
    name                                       = string
    sku_name                                   = string
    mtu                                        = optional(string)
    key_vault_key_id                           = optional(any)
    automatically_rotate_key_to_latest_enabled = optional(bool)
    tags                                       = optional(map(string))
    ntp_server                                 = optional(string)
    default_access_policy = optional(list(object({
      access_rule = optional(list(object({
        scope                   = string
        access                  = optional(string)
        filter                  = optional(string)
        suid_enabled            = optional(bool)
        submount_access_enabled = optional(bool)
        root_squash_enabled     = optional(bool)
        anonymous_uid           = optional(number)
        anonymous_gid           = optional(number)
      })))
    })))
    directory_active_directory = optional(list(object({
      cache_netbios_name  = string
      dns_primary_ip      = string
      domain_name         = string
      domain_netbios_name = string
      password            = string
      username            = string
    })))
    directory_flat_file = optional(list(object({
      group_file_uri    = string
      password_file_uri = string
    })))
    directory_ldap = optional(list(object({
      base_dn                            = string
      server                             = string
      encrypted                          = optional(bool)
      certificate_validation_uri         = optional(string)
      bind = optional(list(object({
        dn       = optional(string)
        password = optional(string)
      })))
    })))
    dns = optional(list(object({
      servers       = optional(list(string))
      search_domain = optional(string)
    })))
    identity_type = optional(string)
    identity_ids = optional(list(string))
  }))
  default = []
}

variable "account" {
  type = list(object({
    id                                = number
    account_replication_type          = string
    account_tier                      = string
    name                              = string
    account_kind                      = optional(string)
    access_tier                       = optional(string)
    cross_tenant_replication_enabled  = optional(bool)
    edge_zone                         = optional(string)
    https_traffic_only_enabled        = optional(bool)
    min_tls_version                   = optional(string)
    allow_nested_items_to_be_public   = optional(bool)
    shared_access_key_enabled         = optional(bool)
    public_network_access_enabled     = optional(bool)
    default_to_oauth_authentication   = optional(bool)
    is_hns_enabled                    = optional(bool)
    nfsv3_enabled                     = optional(bool)
    large_file_share_enabled          = optional(bool)
    local_user_enabled                = optional(bool)
    queue_encryption_key_type         = optional(string)
    table_encryption_key_type         = optional(string)
    infrastructure_encryption_enabled = optional(bool)
    sftp_enabled                      = optional(bool)
    dns_endpoint_type                 = optional(string)
    tags                              = optional(map(string))
    custom_domain_name                = optional(string)
    use_subdomain                     = optional(bool)
    azure_files_authentication = optional(list(object({
      directory_type                 = string
      default_share_level_permission = optional(string)
      active_directory = optional(list(object({
        domain_guid         = string
        domain_name         = string
        domain_sid          = optional(string)
        storage_sid         = optional(string)
        forest_name         = optional(string)
        netbios_domain_name = optional(string)
      })))
    })))
    blob_properties = optional(list(object({
      versioning_enabled            = optional(bool)
      change_feed_enabled           = optional(bool)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      last_access_time_enabled      = optional(bool)
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = optional(number)
      })))
      container_delete_retention_policy_days = optional(number)
      delete_retention_policy = optional(list(object({
        days                     = optional(number)
        permanent_delete_enabled = optional(bool)
      })))
      restore_policy_days = optional(number)
    })))
    customer_managed_key = optional(list(object({
      user_assigned_identity_id = string
    })))
    identity = optional(list(object({
      type         = string
      identity_ids = optional(list(string))
    })))
    immutability_policy = optional(list(object({
      allow_protected_append_writes = bool
      period_since_creation_in_days = number
      state                         = string
    })))
    network_rules = optional(list(object({
      default_action             = string
      bypass                     = optional(list(string))
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
    })))
  }))
  default = []
}