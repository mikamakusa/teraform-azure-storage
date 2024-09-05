## TAGS ##

variable "tags" {
  type    = map(string)
  default = {}
}

## DATAS ##

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type    = string
  default = null
}

variable "subnet_name" {
  type    = string
  default = null
}

variable "network_interface_name" {
  type    = string
  default = null
}

variable "virtual_machine_name" {
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
      base_dn                    = string
      server                     = string
      encrypted                  = optional(bool)
      certificate_validation_uri = optional(string)
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
    identity_ids  = optional(list(string))
  }))
  default = []

  validation {
    condition = length([
      for a in var.hpc_cache : true if contains(["3072", "6144", "12288", "21623", "24576", "43246", "49152", "86491"], a.cache_size_in_gb)
    ]) == length(var.hpc_cache)
    error_message = "Possible values are 3072, 6144, 12288, 21623, 24576, 43246, 49152 and 86491."
  }

  validation {
    condition = length([
      for b in var.hpc_cache : true if contains(["Standard_2G", "Standard_4G", "Standard_8G", "Standard_L4_5G", "Standard_L9G", "Standard_L16G"], b.sku_name)
    ]) == length(var.hpc_cache)
    error_message = "Possible values are (ReadWrite) - Standard_2G, Standard_4G Standard_8G or (ReadOnly) - Standard_L4_5G, Standard_L9G, and Standard_L16G."
  }

  validation {
    condition = length([
      for c in var.hpc_cache : true if contains(["default", "network", "host"], c.default_access_policy.access_rule.scope)
    ]) == length(var.hpc_cache)
    error_message = "Possible values are: default, network, host."
  }

  validation {
    condition = length([
      for d in var.hpc_cache : true if contains(["rw", "ro", "no"], d.default_access_policy.access_rule.access)
    ]) == length(var.hpc_cache)
    error_message = "Possible values are: rw, ro, no."
  }

  validation {
    condition = length([
      for e in var.hpc_cache : true if contains(["SystemAssigned", "UserAssigned"], e.identity_type)
    ]) == length(var.hpc_cache)
    error_message = "Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
  }
}

variable "hpc_cache_access_policy" {
  type = list(object({
    id           = number
    hpc_cache_id = any
    name         = string
    access_rule = list(object({
      access                  = string
      scope                   = string
      filter                  = optional(string)
      suid_enabled            = optional(bool)
      submount_access_enabled = optional(bool)
      root_squash_enabled     = optional(bool)
      anonymous_gid           = optional(number)
      anonymous_uid           = optional(number)
    }))
  }))
  default = []

  validation {
    condition = length([
      for c in var.hpc_cache_access_policy : true if contains(["default", "network", "host"], c.access_rule.scope)
    ]) == length(var.hpc_cache_access_policy)
    error_message = "Possible values are: default, network, host."
  }

  validation {
    condition = length([
      for d in var.hpc_cache_access_policy : true if contains(["rw", "ro", "no"], d.access_rule.access)
    ]) == length(var.hpc_cache_access_policy)
    error_message = "Possible values are: rw, ro, no."
  }
}

variable "hpc_cache_blob_nfs_target" {
  type = list(object({
    id                            = number
    hpc_cache_id                  = any
    name                          = string
    namespace_path                = string
    storage_container_id          = any
    usage_model                   = string
    verification_timer_in_seconds = optional(number)
    write_back_timer_in_seconds   = optional(number)
    access_policy_id              = optional(any)
  }))
  default = []

  validation {
    condition = length([
      for a in var.hpc_cache_blob_nfs_target : true if contains(["READ_HEAVY_INFREQ", "READ_HEAVY_CHECK_180", "READ_ONLY", "READ_WRITE", "WRITE_WORKLOAD_15", "WRITE_AROUND", "WRITE_WORKLOAD_CHECK_30", "WRITE_WORKLOAD_CHECK_60", "WRITE_WORKLOAD_CLOUDWS"], a.usage_model)
    ]) == length(var.hpc_cache_blob_nfs_target)
    error_message = "Possible values are: READ_HEAVY_INFREQ, READ_HEAVY_CHECK_180, READ_ONLY, READ_WRITE, WRITE_WORKLOAD_15, WRITE_AROUND, WRITE_WORKLOAD_CHECK_30, WRITE_WORKLOAD_CHECK_60 and WRITE_WORKLOAD_CLOUDWS."
  }

  validation {
    condition = length([
      for b in var.hpc_cache_blob_nfs_target : true if b.verification_timer_in_seconds >= 1 && b.verification_timer_in_seconds <= 31536000
    ]) == length(var.hpc_cache_blob_nfs_target)
    error_message = "Possible values are between 1 and 31536000."
  }

  validation {
    condition = length([
      for c in var.hpc_cache_blob_nfs_target : true if c.write_back_timer_in_seconds >= 1 && c.write_back_timer_in_seconds <= 31536000
    ]) == length(var.hpc_cache_blob_nfs_target)
    error_message = "Possible values are between 1 and 31536000."
  }
}

variable "hpc_cache_blob_target" {
  type = list(object({
    id                   = number
    hpc_cache_id         = any
    name                 = string
    namespace_path       = string
    storage_container_id = any
    access_policy_id     = optional(any)
  }))
  default = []
}

variable "hpc_cache_nfs_target" {
  type = list(object({
    id                            = number
    cache_id                      = any
    name                          = string
    usage_model                   = string
    verification_timer_in_seconds = optional(number)
    write_back_timer_in_seconds   = optional(number)
    namespace_junction = list(object({
      namespace_path     = string
      nfs_export         = string
      target_path        = optional(string)
      access_policy_name = optional(string)
    }))
  }))
  default = []

  validation {
    condition = length([
      for a in var.hpc_cache_nfs_target : true if contains(["READ_HEAVY_INFREQ", "READ_HEAVY_CHECK_180", "READ_ONLY", "READ_WRITE", "WRITE_WORKLOAD_15", "WRITE_AROUND", "WRITE_WORKLOAD_CHECK_30", "WRITE_WORKLOAD_CHECK_60", "WRITE_WORKLOAD_CLOUDW"], a.usage_model)
    ]) == length(var.hpc_cache_nfs_target)
    error_message = "Possible values are: READ_HEAVY_INFREQ, READ_HEAVY_CHECK_180, READ_ONLY, READ_WRITE, WRITE_WORKLOAD_15, WRITE_AROUND, WRITE_WORKLOAD_CHECK_30, WRITE_WORKLOAD_CHECK_60 and WRITE_WORKLOAD_CLOUDWS."
  }

  validation {
    condition = length([
      for b in var.hpc_cache_nfs_target : true if b.verification_timer_in_seconds >= 1 && b.verification_timer_in_seconds <= 31336000
    ]) == length(var.hpc_cache_nfs_target)
    error_message = "Possible values are between 1 and 31536000."
  }

  validation {
    condition = length([
      for c in var.hpc_cache_nfs_target : true if c.write_back_timer_in_seconds >= 1 && c.write_back_timer_in_seconds <= 31336000
    ]) == length(var.hpc_cache_nfs_target)
    error_message = "Possible values are between 1 and 31536000."
  }
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
      user_assigned_identity_id = optional(string)
      key_vault_key_id          = any
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

variable "customer_managed_key" {
  type = list(object({
    id                 = number
    key_id             = any
    storage_account_id = any
    key_vault_id       = optional(any)
    key_version        = optional(string)
  }))
  default = []
}

variable "local_user" {
  type = list(object({
    id                   = number
    name                 = string
    storage_account_id   = any
    home_directory       = optional(string)
    ssh_key_enabled      = optional(bool)
    ssh_password_enabled = optional(bool)
    permission_scope = optional(list(object({
      resource_name = string
      service       = string
      permissions = optional(list(object({
        all    = optional(bool)
        create = optional(bool)
        delete = optional(bool)
        list   = optional(bool)
        read   = optional(bool)
        write  = optional(bool)
      })))
    })))
    ssh_authorized_key = optional(list(object({
      key         = string
      description = optional(string)
    })))
  }))
  default = []
}

variable "network_rules" {
  type = list(object({
    id                         = number
    default_action             = string
    storage_account_id         = any
    bypass                     = optional(any)
    ip_rules                   = optional(set(any))
    virtual_network_subnet_ids = optional(set(any))
    private_link_access = optional(list(object({
      endpoint_resource_id = any
      endpoint_tenant_id   = optional(any)
    })))
  }))
  default = []

  validation {
    condition     = length([for a in var.network_rules : true if contains(["Deny", "Allow"], a.default_action)]) == length(var.network_rules)
    error_message = "Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
  }

  validation {
    condition     = length([for b in var.network_rules : true if contains(["Logging", "Metrics", "AzureServices", "None"], b.bypass)]) == length(var.network_rules)
    error_message = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. Defaults to [\"AzureServices\"]."
  }
}

variable "blob" {
  type = list(object({
    id                   = number
    name                 = string
    storage_account_id   = any
    storage_container_id = any
    type                 = string
    size                 = optional(number)
    access_tier          = optional(string)
    cache_control        = optional(string)
    content_type         = optional(string)
    content_md5          = optional(string)
    encryption_scope     = optional(string)
    source               = optional(string)
    source_content       = optional(string)
    source_uri           = optional(string)
    parallelism          = optional(number)
    metadata             = optional(map(string))
  }))
  default = []

  validation {
    condition     = length([for a in var.blob : true if contains(["Archive", "Cool", "Hot"], a.access_tier)]) == length(var.blob)
    error_message = "The access tier of the storage blob. Possible values are Archive, Cool and Hot."
  }

  validation {
    condition     = length([for b in var.blob : true if contains(["Append", "Block", "Page"], b.type)]) == length(var.blob)
    error_message = "The type of the storage blob to be created. Possible values are Append, Block or Page. Changing this forces a new resource to be created."
  }
}

variable "blob_inventory_policy" {
  type = list(object({
    id                 = number
    storage_account_id = any
    rules = list(object({
      format               = string
      name                 = string
      schedule             = string
      schema_fields        = set(any)
      scope                = string
      storage_container_id = any
      filter = optional(list(object({
        blob_types            = set(any)
        include_blob_versions = optional(bool)
        include_deleted       = optional(bool)
        include_snapshots     = optional(bool)
        prefix_match          = optional(set(any))
        exclude_prefixes      = optional(set(any))
      })))
    }))
  }))
  default = []
}

variable "container" {
  type = list(object({
    id                                = number
    name                              = string
    storage_account_id                = any
    container_access_type             = optional(string)
    default_encryption_scope          = optional(string)
    encryption_scope_override_enabled = optional(bool)
    metadata                          = optional(map(string))
  }))
  default = []
}

variable "container_immutability_policy" {
  type = list(object({
    id                                  = number
    immutability_period_in_days         = number
    storage_container_id                = any
    locked                              = optional(bool)
    protected_append_writes_all_enabled = optional(bool)
    protected_append_writes_enabled     = optional(bool)
  }))
  default = []
}

variable "data_lake_gen2_filesystem" {
  type = list(object({
    id                       = number
    name                     = string
    storage_account_id       = any
    default_encryption_scope = optional(string)
    properties               = optional(map(string))
    owner                    = optional(string)
    group                    = optional(string)
    ace = optional(list(object({
      permissions = string
      type        = string
      scope       = optional(string)
      id          = optional(string)
    })))
  }))
  default = []
}

variable "data_lake_gen2_path" {
  type = list(object({
    id                 = number
    filesystem_id      = any
    path               = string
    resource           = string
    storage_account_id = any
    owner              = optional(string)
    group              = optional(string)
    ace = optional(list(object({
      permissions = string
      type        = string
      scope       = optional(string)
      id          = optional(string)
    })))
  }))
  default = []
}

variable "encryption_scope" {
  type = list(object({
    id                                 = number
    name                               = string
    source                             = string
    storage_account_id                 = any
    infrastructure_encryption_required = optional(bool)
    key_vault_key_id                   = optional(any)
  }))
  default = []

  validation {
    condition     = length([for a in var.encryption_scope : true if contains(["Microsoft.KeyVault", "Microsoft.Storage"], a.source)]) == length(var.encryption_scope)
    error_message = "The source of the Storage Encryption Scope. Possible values are Microsoft.KeyVault and Microsoft.Storage."
  }
}

variable "management_policy" {
  type = list(object({
    id                 = number
    storage_account_id = any
    rule = optional(list(object({
      enabled = bool
      name    = string
      filters = optional(list(object({
        blob_types   = set(any)
        prefix_match = optional(set(any))
        match_blob_index_tag = optional(list(object({
          name      = string
          value     = string
          operation = optional(set())
        })))
      })))
      actions = optional(list(object({
        base_blob = optional(list(object({
          tier_to_archive_after_days_since_creation_greater_than         = optional(number)
          tier_to_archive_after_days_since_last_access_time_greater_than = optional(number)
          tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          tier_to_archive_after_days_since_modification_greater_than     = optional(number)
          tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          tier_to_cold_after_days_since_last_access_time_greater_than    = optional(number)
          tier_to_cold_after_days_since_modification_greater_than        = optional(number)
          tier_to_cool_after_days_since_creation_greater_than            = optional(number)
          tier_to_cool_after_days_since_last_access_time_greater_than    = optional(number)
          tier_to_cool_after_days_since_modification_greater_than        = optional(number)
          auto_tier_to_hot_from_cool_enabled                             = optional(bool)
          delete_after_days_since_creation_greater_than                  = optional(number)
          delete_after_days_since_last_access_time_greater_than          = optional(number)
          delete_after_days_since_modification_greater_than              = optional(number)
        })))
        snapshot = optional(list(object({
          change_tier_to_archive_after_days_since_creation               = optional(number)
          change_tier_to_cool_after_days_since_creation                  = optional(number)
          tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          delete_after_days_since_creation_greater_than                  = optional(number)
        })))
        version = optional(list(object({
          change_tier_to_archive_after_days_since_creation               = optional(number)
          change_tier_to_cool_after_days_since_creation                  = optional(number)
          tier_to_archive_after_days_since_last_tier_change_greater_than = optional(number)
          tier_to_cold_after_days_since_creation_greater_than            = optional(number)
          delete_after_days_since_creation                               = optional(number)
        })))
      })))
    })))
  }))
  default = []
}

variable "object_replication" {
  type = list(object({
    id                             = number
    destination_storage_account_id = any
    source_storage_account_id      = any
    rules = list(object({
      destination_container_name   = any
      source_container_name        = any
      copy_blobs_created_after     = optional(string)
      filter_out_blobs_with_prefix = optional(set(string))
    }))
  }))
}