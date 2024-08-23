## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.116.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.116.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | modules/terraform-azure-keyvault | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_hpc_cache.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/hpc_cache) | resource |
| [azurerm_hpc_cache_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/hpc_cache_access_policy) | resource |
| [azurerm_hpc_cache_blob_nfs_target.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/hpc_cache_blob_nfs_target) | resource |
| [azurerm_hpc_cache_blob_target.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/hpc_cache_blob_target) | resource |
| [azurerm_hpc_cache_nfs_target.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/hpc_cache_nfs_target) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | n/a | <pre>list(object({<br>    id                                = number<br>    account_replication_type          = string<br>    account_tier                      = string<br>    name                              = string<br>    account_kind                      = optional(string)<br>    access_tier                       = optional(string)<br>    cross_tenant_replication_enabled  = optional(bool)<br>    edge_zone                         = optional(string)<br>    https_traffic_only_enabled        = optional(bool)<br>    min_tls_version                   = optional(string)<br>    allow_nested_items_to_be_public   = optional(bool)<br>    shared_access_key_enabled         = optional(bool)<br>    public_network_access_enabled     = optional(bool)<br>    default_to_oauth_authentication   = optional(bool)<br>    is_hns_enabled                    = optional(bool)<br>    nfsv3_enabled                     = optional(bool)<br>    large_file_share_enabled          = optional(bool)<br>    local_user_enabled                = optional(bool)<br>    queue_encryption_key_type         = optional(string)<br>    table_encryption_key_type         = optional(string)<br>    infrastructure_encryption_enabled = optional(bool)<br>    sftp_enabled                      = optional(bool)<br>    dns_endpoint_type                 = optional(string)<br>    tags                              = optional(map(string))<br>    custom_domain_name                = optional(string)<br>    use_subdomain                     = optional(bool)<br>    azure_files_authentication = optional(list(object({<br>      directory_type                 = string<br>      default_share_level_permission = optional(string)<br>      active_directory = optional(list(object({<br>        domain_guid         = string<br>        domain_name         = string<br>        domain_sid          = optional(string)<br>        storage_sid         = optional(string)<br>        forest_name         = optional(string)<br>        netbios_domain_name = optional(string)<br>      })))<br>    })))<br>    blob_properties = optional(list(object({<br>      versioning_enabled            = optional(bool)<br>      change_feed_enabled           = optional(bool)<br>      change_feed_retention_in_days = optional(number)<br>      default_service_version       = optional(string)<br>      last_access_time_enabled      = optional(bool)<br>      cors_rule = optional(list(object({<br>        allowed_headers    = list(string)<br>        allowed_methods    = list(string)<br>        allowed_origins    = list(string)<br>        exposed_headers    = list(string)<br>        max_age_in_seconds = optional(number)<br>      })))<br>      container_delete_retention_policy_days = optional(number)<br>      delete_retention_policy = optional(list(object({<br>        days                     = optional(number)<br>        permanent_delete_enabled = optional(bool)<br>      })))<br>      restore_policy_days = optional(number)<br>    })))<br>    customer_managed_key = optional(list(object({<br>      user_assigned_identity_id = optional(string)<br>      key_vault_key_id          = any<br>    })))<br>    identity = optional(list(object({<br>      type         = string<br>      identity_ids = optional(list(string))<br>    })))<br>    immutability_policy = optional(list(object({<br>      allow_protected_append_writes = bool<br>      period_since_creation_in_days = number<br>      state                         = string<br>    })))<br>    network_rules = optional(list(object({<br>      default_action             = string<br>      bypass                     = optional(list(string))<br>      ip_rules                   = optional(list(string))<br>      virtual_network_subnet_ids = optional(list(string))<br>      private_link_access = optional(list(object({<br>        endpoint_resource_id = string<br>        endpoint_tenant_id   = optional(string)<br>      })))<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_container"></a> [container](#input\_container) | n/a | <pre>list(object({<br>    id                 = number<br>    name               = string<br>    storage_account_id = optional(any)<br>  }))</pre> | `[]` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | n/a | <pre>list(object({<br>    id                 = number<br>    key_id             = any<br>    storage_account_id = any<br>    key_vault_id       = optional(any)<br>    key_version        = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_hpc_cache"></a> [hpc\_cache](#input\_hpc\_cache) | n/a | <pre>list(object({<br>    id                                         = number<br>    cache_size_in_gb                           = number<br>    name                                       = string<br>    sku_name                                   = string<br>    mtu                                        = optional(string)<br>    key_vault_key_id                           = optional(any)<br>    automatically_rotate_key_to_latest_enabled = optional(bool)<br>    tags                                       = optional(map(string))<br>    ntp_server                                 = optional(string)<br>    default_access_policy = optional(list(object({<br>      access_rule = optional(list(object({<br>        scope                   = string<br>        access                  = optional(string)<br>        filter                  = optional(string)<br>        suid_enabled            = optional(bool)<br>        submount_access_enabled = optional(bool)<br>        root_squash_enabled     = optional(bool)<br>        anonymous_uid           = optional(number)<br>        anonymous_gid           = optional(number)<br>      })))<br>    })))<br>    directory_active_directory = optional(list(object({<br>      cache_netbios_name  = string<br>      dns_primary_ip      = string<br>      domain_name         = string<br>      domain_netbios_name = string<br>      password            = string<br>      username            = string<br>    })))<br>    directory_flat_file = optional(list(object({<br>      group_file_uri    = string<br>      password_file_uri = string<br>    })))<br>    directory_ldap = optional(list(object({<br>      base_dn                    = string<br>      server                     = string<br>      encrypted                  = optional(bool)<br>      certificate_validation_uri = optional(string)<br>      bind = optional(list(object({<br>        dn       = optional(string)<br>        password = optional(string)<br>      })))<br>    })))<br>    dns = optional(list(object({<br>      servers       = optional(list(string))<br>      search_domain = optional(string)<br>    })))<br>    identity_type = optional(string)<br>    identity_ids  = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_hpc_cache_access_policy"></a> [hpc\_cache\_access\_policy](#input\_hpc\_cache\_access\_policy) | n/a | <pre>list(object({<br>    id           = number<br>    hpc_cache_id = any<br>    name         = string<br>    access_rule = list(object({<br>      access                  = string<br>      scope                   = string<br>      filter                  = optional(string)<br>      suid_enabled            = optional(bool)<br>      submount_access_enabled = optional(bool)<br>      root_squash_enabled     = optional(bool)<br>      anonymous_gid           = optional(number)<br>      anonymous_uid           = optional(number)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_hpc_cache_blob_nfs_target"></a> [hpc\_cache\_blob\_nfs\_target](#input\_hpc\_cache\_blob\_nfs\_target) | n/a | <pre>list(object({<br>    id                            = number<br>    hpc_cache_id                  = any<br>    name                          = string<br>    namespace_path                = string<br>    storage_container_id          = any<br>    usage_model                   = string<br>    verification_timer_in_seconds = optional(number)<br>    write_back_timer_in_seconds   = optional(number)<br>    access_policy_id              = optional(any)<br>  }))</pre> | `[]` | no |
| <a name="input_hpc_cache_blob_target"></a> [hpc\_cache\_blob\_target](#input\_hpc\_cache\_blob\_target) | n/a | <pre>list(object({<br>    id                   = number<br>    hpc_cache_id         = any<br>    name                 = string<br>    namespace_path       = string<br>    storage_container_id = any<br>    access_policy_id     = optional(any)<br>  }))</pre> | `[]` | no |
| <a name="input_hpc_cache_nfs_target"></a> [hpc\_cache\_nfs\_target](#input\_hpc\_cache\_nfs\_target) | n/a | <pre>list(object({<br>    id                            = number<br>    cache_id                      = any<br>    name                          = string<br>    usage_model                   = string<br>    verification_timer_in_seconds = optional(number)<br>    write_back_timer_in_seconds   = optional(number)<br>    namespace_junction = list(object({<br>      namespace_path     = string<br>      nfs_export         = string<br>      target_path        = optional(string)<br>      access_policy_name = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_keyvault"></a> [keyvault](#input\_keyvault) | n/a | `any` | `[]` | no |
| <a name="input_keyvault_key"></a> [keyvault\_key](#input\_keyvault\_key) | n/a | `any` | `[]` | no |
| <a name="input_network_interface_name"></a> [network\_interface\_name](#input\_network\_interface\_name) | n/a | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | n/a | `string` | `null` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_id"></a> [container\_id](#output\_container\_id) | n/a |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | n/a |
| <a name="output_customer_manager_key_id"></a> [customer\_manager\_key\_id](#output\_customer\_manager\_key\_id) | n/a |
| <a name="output_customer_manager_key_storage_account_id"></a> [customer\_manager\_key\_storage\_account\_id](#output\_customer\_manager\_key\_storage\_account\_id) | n/a |
| <a name="output_customer_manager_key_vault_id"></a> [customer\_manager\_key\_vault\_id](#output\_customer\_manager\_key\_vault\_id) | n/a |
| <a name="output_hpc_cache_access_policy_id"></a> [hpc\_cache\_access\_policy\_id](#output\_hpc\_cache\_access\_policy\_id) | n/a |
| <a name="output_hpc_cache_access_policy_name"></a> [hpc\_cache\_access\_policy\_name](#output\_hpc\_cache\_access\_policy\_name) | n/a |
| <a name="output_hpc_cache_blob_nfs_target_id"></a> [hpc\_cache\_blob\_nfs\_target\_id](#output\_hpc\_cache\_blob\_nfs\_target\_id) | n/a |
| <a name="output_hpc_cache_blob_nfs_target_name"></a> [hpc\_cache\_blob\_nfs\_target\_name](#output\_hpc\_cache\_blob\_nfs\_target\_name) | n/a |
| <a name="output_hpc_cache_blob_target_id"></a> [hpc\_cache\_blob\_target\_id](#output\_hpc\_cache\_blob\_target\_id) | n/a |
| <a name="output_hpc_cache_blob_target_name"></a> [hpc\_cache\_blob\_target\_name](#output\_hpc\_cache\_blob\_target\_name) | n/a |
| <a name="output_hpc_cache_id"></a> [hpc\_cache\_id](#output\_hpc\_cache\_id) | n/a |
| <a name="output_hpc_cache_name"></a> [hpc\_cache\_name](#output\_hpc\_cache\_name) | n/a |
| <a name="output_hpc_cache_nfs_target_id"></a> [hpc\_cache\_nfs\_target\_id](#output\_hpc\_cache\_nfs\_target\_id) | n/a |
| <a name="output_hpc_cache_nfs_target_name"></a> [hpc\_cache\_nfs\_target\_name](#output\_hpc\_cache\_nfs\_target\_name) | n/a |
| <a name="output_hpc_cache_sku_name"></a> [hpc\_cache\_sku\_name](#output\_hpc\_cache\_sku\_name) | n/a |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | n/a |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | n/a |
| <a name="output_storage_account_primary_blob_connection_string"></a> [storage\_account\_primary\_blob\_connection\_string](#output\_storage\_account\_primary\_blob\_connection\_string) | n/a |
| <a name="output_storage_account_primary_connection_string"></a> [storage\_account\_primary\_connection\_string](#output\_storage\_account\_primary\_connection\_string) | n/a |
