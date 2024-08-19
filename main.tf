resource "azurerm_hpc_cache" "this" {
  count                                      = length(var.hpc_cache)
  cache_size_in_gb                           = lookup(var.hpc_cache[count.index], "cache_size_in_gb")
  location                                   = data.azurerm_resource_group.this.location
  name                                       = lookup(var.hpc_cache[count.index], "name")
  resource_group_name                        = data.azurerm_resource_group.this.name
  sku_name                                   = lookup(var.hpc_cache[count.index], "sku_name")
  subnet_id                                  = data.azurerm_subnet.this.id
  mtu                                        = lookup(var.hpc_cache[count.index], "mtu")
  key_vault_key_id                           = try(element(module.key_vault.*.key_vault_key_id, lookup(var.hpc_cache[count.index], "key_vault_key_id")))
  automatically_rotate_key_to_latest_enabled = lookup(var.hpc_cache[count.index], "automatically_rotate_key_to_latest_enabled")
  tags                                       = merge(var.tags, lookup(var.hpc_cache[count.index], "tags"))
  ntp_server                                 = lookup(var.hpc_cache[count.index], "ntp_server")

  dynamic "default_access_policy" {
    for_each = lookup(var.hpc_cache[count.index], "default_access_policy") == null ? [] : ["default_access_policy"]
    content {
      dynamic "access_rule" {
        for_each = lookup(default_access_policy.value, "access_rule") == null ? [] : ["access_rule"]
        content {
          scope                   = lookup(access_rule.value, "scope")
          access                  = lookup(access_rule.value, "access")
          filter                  = lookup(access_rule.value, "filter")
          suid_enabled            = lookup(access_rule.value, "suid_enabled")
          submount_access_enabled = lookup(access_rule.value, "submount_access_enabled")
          root_squash_enabled     = lookup(access_rule.value, "root_squash_enabled")
          anonymous_uid           = lookup(access_rule.value, "root_squash_enabled") == true ? lookup(access_rule.value, "anonymous_uid") : null
          anonymous_gid           = lookup(access_rule.value, "root_squash_enabled") == true ? lookup(access_rule.value, "anonymous_gid") : null
        }
      }
    }
  }

  dynamic "directory_active_directory" {
    for_each = lookup(var.hpc_cache[count.index], "directory_active_directory") == null ? [] : ["directory_active_directory"]
    content {
      cache_netbios_name  = lookup(directory_active_directory.value, "cache_netbios_name")
      dns_primary_ip      = lookup(directory_active_directory.value, "dns_primary_ip")
      domain_name         = lookup(directory_active_directory.value, "domain_name")
      domain_netbios_name = lookup(directory_active_directory.value, "domain_netbios_name")
      password            = lookup(directory_active_directory.value, "password")
      username            = lookup(directory_active_directory.value, "username")
    }
  }

  dynamic "directory_flat_file" {
    for_each = lookup(var.hpc_cache[count.index], "directory_flat_file") == null ? [] : ["directory_flat_file"]
    content {
      group_file_uri    = lookup(directory_flat_file.value, "group_file_uri")
      password_file_uri = lookup(directory_flat_file.value, "password_file_uri")
    }
  }

  dynamic "directory_ldap" {
    for_each = lookup(var.hpc_cache[count.index], "directory_ldap") == null ? [] : ["directory_ldap"]
    content {
      base_dn                            = lookup(directory_ldap.value, "base_dn")
      server                             = lookup(directory_ldap.value, "server")
      encrypted                          = lookup(directory_ldap.value, "encrypted")
      certificate_validation_uri         = lookup(directory_ldap.value, "certificate_validation_uri")
      download_certificate_automatically = lookup(directory_ldap.value, "certificate_validation_uri") == true ? lookup(directory_ldap.value, "download_certificate_automatically") : false

      dynamic "bind" {
        for_each = lookup(directory_ldap.value, "bind") == null ? [] : ["bind"]
        content {
          dn       = lookup(bind.value, "dn")
          password = sensitive(lookup(bind.value, "password"))
        }
      }
    }
  }

  dynamic "dns" {
    for_each = lookup(var.hpc_cache[count.index], "dns") == null ? [] : ["dns"]
    content {
      servers       = lookup(dns.value, "servers")
      search_domain = lookup(dns.value, "search_domain")
    }
  }

  dynamic "identity" {
    for_each = lookup(var.hpc_cache[count.index], "identity_type") != null ? ["identity"] : []
    content {
      type         = lookup(var.hpc_cache[count.index], "identity_type")
      identity_ids = lookup(var.hpc_cache[count.index], "identity_ids")
    }
  }
}

resource "azurerm_hpc_cache_access_policy" "this" {
  count        = length(var.hpc_cache) == 0 ? 0 : length(var.hpc_cache_access_policy)
  hpc_cache_id = try(element(azurerm_hpc_cache.this.*.id, lookup(var.hpc_cache_access_policy[count.index], "hpc_cache_id")))
  name         = lookup(var.hpc_cache_access_policy[count.index], "name")

  dynamic "access_rule" {
    for_each = lookup(var.hpc_cache_access_policy[count.index], "access_rule")
    content {
      access                  = lookup(access_rule.value, "access")
      scope                   = lookup(access_rule.value, "scope")
      filter                  = lookup(access_rule.value, "filter")
      suid_enabled            = lookup(access_rule.value, "suid_enabled")
      submount_access_enabled = lookup(access_rule.value, "submount_access_enabled")
      root_squash_enabled     = lookup(access_rule.value, "root_squash_enabled")
      anonymous_gid           = lookup(access_rule.value, "root_squash_enabled") == true ? lookup(access_rule.value, "anonymous_gid") : null
      anonymous_uid           = lookup(access_rule.value, "root_squash_enabled") == true ? lookup(access_rule.value, "anonymous_uid") : null
    }
  }
}

resource "azurerm_hpc_cache_blob_nfs_target" "this" {
  count                         = (length(var.container) && length(var.hpc_cache)) == 0 ? 0 : length(var.hpc_cache_blob_nfs_target)
  cache_name                    = try(element(azurerm_hpc_cache.this.*.name, lookup(var.hpc_cache_blob_nfs_target[count.index], "hpc_cache_id")))
  name                          = lookup(var.hpc_cache_blob_nfs_target[count.index], "name")
  namespace_path                = lookup(var.hpc_cache_blob_nfs_target[count.index], "namespace_path")
  resource_group_name           = data.azurerm_resource_group.this.name
  storage_container_id          = jsonencode(try(element(azurerm_storage_container.this.*.id, lookup(var.hpc_cache_blob_nfs_target[count.index], "storage_container_id"))))
  usage_model                   = lookup(var.hpc_cache_blob_nfs_target[count.index], "usage_model")
  verification_timer_in_seconds = lookup(var.hpc_cache_blob_nfs_target[count.index], "verification_timer_in_seconds")
  write_back_timer_in_seconds   = lookup(var.hpc_cache_blob_nfs_target[count.index], "write_back_timer_in_seconds")
  access_policy_name            = try(element(azurerm_hpc_cache_access_policy.this.*.id, lookup(var.hpc_cache_blob_nfs_target[count.index], "access_policy_id")))
}

resource "azurerm_hpc_cache_blob_target" "this" {
  count                = (length(var.hpc_cache) && length(var.container)) == 0 ? 0 : length(var.hpc_cache_blob_target)
  cache_name           = try(element(azurerm_hpc_cache.this.*.name, lookup(var.hpc_cache_blob_target[count.index], "hpc_cache_id")))
  name                 = lookup(var.hpc_cache_blob_target[count.index], "name")
  namespace_path       = lookup(var.hpc_cache_blob_target[count.index], "namespace_path")
  resource_group_name  = data.azurerm_resource_group.this.name
  storage_container_id = try(element(azurerm_storage_container.this.*.id, lookup(var.hpc_cache_blob_target[count.index], "storage_container_id")))
  access_policy_name   = try(element(azurerm_hpc_cache_access_policy.this.*.name, lookup(var.hpc_cache_blob_target[count.index], "access_policy_id")))
}

resource "azurerm_hpc_cache_nfs_target" "this" {
  count                         = length(var.hpc_cache) == 0 ? 0 : length(var.hpc_cache_nfs_target)
  cache_name                    = try(element(azurerm_hpc_cache.this.*.name, lookup(var.hpc_cache_nfs_target[count.index], "cache_id")))
  name                          = lookup(var.hpc_cache_nfs_target[count.index], "name")
  resource_group_name           = data.azurerm_resource_group.this.name
  target_host_name              = data.azurerm_virtual_machine.this.private_ip_address
  usage_model                   = lookup(var.hpc_cache_nfs_target[count.index], "usage_model")
  verification_timer_in_seconds = lookup(var.hpc_cache_nfs_target[count.index], "verification_timer_in_seconds")
  write_back_timer_in_seconds   = lookup(var.hpc_cache_nfs_target[count.index], "write_back_timer_in_seconds")

  dynamic "namespace_junction" {
    for_each = lookup(var.hpc_cache_nfs_target[count.index], "namespace_junction")
    content {
      namespace_path     = lookup(namespace_junction.value, "namespace_path")
      nfs_export         = lookup(namespace_junction.value, "nfs_export")
      target_path        = lookup(namespace_junction.value, "target_path")
      access_policy_name = lookup(namespace_junction.value, "access_policy_name")
    }
  }
}

resource "azurerm_storage_account" "this" {
  count                             = length(var.account)
  account_replication_type          = lookup(var.account[count.index], "account_replication_type")
  account_tier                      = lookup(var.account[count.index], "account_tier")
  location                          = data.azurerm_resource_group.this.location
  name                              = lookup(var.account[count.index], "name")
  resource_group_name               = data.azurerm_resource_group.this.name
  account_kind                      = lookup(var.account[count.index], "account_kind")
  access_tier                       = lookup(var.account[count.index], "access_tier")
  cross_tenant_replication_enabled  = lookup(var.account[count.index], "cross_tenant_replication_enabled")
  edge_zone                         = lookup(var.account[count.index], "edge_zone")
  https_traffic_only_enabled        = lookup(var.account[count.index], "https_traffic_only_enabled")
  min_tls_version                   = lookup(var.account[count.index], "min_tls_version")
  allow_nested_items_to_be_public   = lookup(var.account[count.index], "allow_nested_items_to_be_public")
  shared_access_key_enabled         = lookup(var.account[count.index], "shared_access_key_enabled")
  public_network_access_enabled     = lookup(var.account[count.index], "public_network_access_enabled")
  default_to_oauth_authentication   = lookup(var.account[count.index], "default_to_oauth_authentication")
  is_hns_enabled                    = lookup(var.account[count.index], "is_hns_enabled")
  nfsv3_enabled                     = lookup(var.account[count.index], "nfsv3_enabled")
  large_file_share_enabled          = lookup(var.account[count.index], "large_file_share_enabled")
  local_user_enabled                = lookup(var.account[count.index], "local_user_enabled")
  queue_encryption_key_type         = lookup(var.account[count.index], "queue_encryption_key_type")
  table_encryption_key_type         = lookup(var.account[count.index], "table_encryption_key_type")
  infrastructure_encryption_enabled = lookup(var.account[count.index], "infrastructure_encryption_enabled")
  sftp_enabled                      = lookup(var.account[count.index], "sftp_enabled")
  dns_endpoint_type                 = lookup(var.account[count.index], "dns_endpoint_type")
  tags                              = merge(var.tags, lookup(var.account[count.index], "tags"))

  dynamic "azure_files_authentication" {
    for_each = lookup(var.account[count.index], "azure_files_authentication") == null ? [] : ["azure_files_authentication"]
    iterator = azure
    content {
      directory_type                 = lookup(azure.value, "directory_type")
      default_share_level_permission = lookup(azure.value, "default_share_level_permission")

      dynamic "active_directory" {
        for_each = (lookup(azure.value, "directory_type") == "AD" || lookup(azure.value, "active_directory") != null) ? ["active_directory"] : []
        content {
          domain_guid         = lookup(active_directory.value, "domain_guid")
          domain_name         = lookup(active_directory.value, "domain_name")
          domain_sid          = lookup(active_directory.value, "domain_sid")
          storage_sid         = lookup(active_directory.value, "storage_sid")
          forest_name         = lookup(active_directory.value, "forest_name")
          netbios_domain_name = lookup(active_directory.value, "netbios_domain_name")
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = lookup(var.account[count.index], "blob_properties") == null ? [] : ["blob_properties"]
    iterator = blob
    content {
      versioning_enabled            = lookup(blob.value, "versioning_enabled")
      change_feed_enabled           = lookup(blob.value, "change_feed_enabled")
      change_feed_retention_in_days = lookup(blob.value, "change_feed_retention_in_days")
      default_service_version       = lookup(blob.value, "default_service_version")
      last_access_time_enabled      = lookup(blob.value, "last_access_time_enabled")

      dynamic "cors_rule" {
        for_each = lookup(blob.value, "cors_rule") == null ? [] : ["cors_rule"]
        content {
          allowed_headers    = lookup(cors_rule.value, "allowed_headers")
          allowed_methods    = lookup(cors_rule.value, "allowed_methods")
          allowed_origins    = lookup(cors_rule.value, "allowed_origins")
          exposed_headers    = lookup(cors_rule.value, "exposed_headers")
          max_age_in_seconds = lookup(cors_rule.value, "max_age_in_seconds")
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = lookup(blob.value, "container_delete_retention_policy_days") != null ? ["container_delete_retention_policy"] : []
        content {
          days = lookup(blob.value, "container_delete_retention_policy_days")
        }
      }

      dynamic "delete_retention_policy" {
        for_each = lookup(blob.value, "delete_retention_policy") == null ? [] : ["delete_retention_policy"]
        content {
          days                     = lookup(delete_retention_policy.value, "days")
          permanent_delete_enabled = lookup(delete_retention_policy.value, "permanent_delete_enabled")
        }
      }

      dynamic "restore_policy" {
        for_each = lookup(blob.value, "restore_policy_days") != null ? ["restore_policy"] : []
        content {
          days = lookup(blob.value, "restore_policy_days")
        }
      }
    }
  }

  dynamic "custom_domain" {
    for_each = lookup(var.account[count.index], "custom_domain_name") != null ? ["custom_domain"] : []
    content {
      name          = lookup(var.account[count.index], "custom_domain_name")
      use_subdomain = lookup(var.account[count.index], "use_subdomain")
    }
  }

  dynamic "customer_managed_key" {
    for_each = lookup(var.account[count.index], "customer_managed_key") == null ? [] : ["customer_managed_key"]
    content {
      user_assigned_identity_id = lookup(customer_managed_key.value, "user_assigned_identity_id")
      #managed_hsm_key_id = ""
      key_vault_key_id = try(element(module.key_vault.*.key_vault_key_id, lookup(customer_managed_key.value, "key_vault_key_id")))
    }
  }

  dynamic "identity" {
    for_each = lookup(var.account[count.index], "identity") == null ? [] : ["identity"]
    content {
      type         = lookup(identity.value, "type")
      identity_ids = lookup(identity.value, "identity_ids")
    }
  }

  dynamic "immutability_policy" {
    for_each = lookup(var.account[count.index], "immutability_policy") == null ? [] : ["immutability_policy"]
    iterator = immutability
    content {
      allow_protected_append_writes = lookup(immutability.value, "allow_protected_append_writes")
      period_since_creation_in_days = lookup(immutability.value, "period_since_creation_in_days")
      state                         = lookup(immutability.value, "state")
    }
  }

  dynamic "network_rules" {
    for_each = lookup(var.account[count.index], "network_rules") == null ? [] : ["network_rules"]
    content {
      default_action             = lookup(network_rules.value, "default_action")
      bypass                     = lookup(network_rules.value, "bypass")
      ip_rules                   = lookup(network_rules.value, "ip_rules")
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids")

      dynamic "private_link_access" {
        for_each = lookup(network_rules.value, "private_link_access") == null ? [] : ["private_link_access"]
        content {
          endpoint_resource_id = lookup(private_link_access.value, "endpoint_resource_id")
          endpoint_tenant_id   = lookup(private_link_access.value, "endpoint_tenant_id")
        }
      }
    }
  }
  /*
    dynamic "queue_properties" {
      for_each = ""
      content {    }
  /*
    dynamic "routing" {
      for_each = ""
      content {}
    }

    dynamic "sas_policy" {
      for_each = ""
      content {
        expiration_period = ""
      }
    }

    dynamic "share_properties" {
      for_each = ""
      content {}
    }

    dynamic "static_website" {
      for_each = ""
      content {}
    }*/
}

resource "azurerm_storage_account_customer_managed_key" "this" {
  count              = (length(var.keyvault_key) && length(var.account)) == 0 ? 0 : length(var.customer_managed_key)
  key_name           = try(element(module.key_vault.*.key_vault_key_name, lookup(var.customer_managed_key[count.index], "key_id")))
  storage_account_id = try(element(azurerm_storage_account.this.*.id, lookup(var.customer_managed_key[count.index], "storage_account_id")))
  key_vault_id       = try(element(module.key_vault.key_vault_id, lookup(var.customer_managed_key[count.index], "key_vault_id")))
  key_version        = lookup(var.customer_managed_key[count.index], "key_version")
  #user_assigned_identity_id = ""
  #federated_identity_client_id = ""
}

resource "azurerm_storage_container" "this" {
  count                = length(var.account) == 0 ? 0 : length(var.container)
  name                 = lookup(var.container[count.index], "name")
  storage_account_name = try(element(azurerm_storage_account.this.*.name, lookup(var.container[count.index], "storage_account_id")))
}