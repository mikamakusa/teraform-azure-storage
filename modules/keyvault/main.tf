resource "azurerm_key_vault" "this" {
  count                           = length(var.key_vault)
  location                        = data.azurerm_resource_group.this.location
  name                            = lookup(var.key_vault[count.index], "name")
  resource_group_name             = data.azurerm_resource_group.this.name
  sku_name                        = lookup(var.key_vault[count.index], "sku_name")
  tenant_id                       = data.azurerm_client_config.this.tenant_id
  enable_rbac_authorization       = lookup(var.key_vault[count.index], "enable_rbac_authorization")
  enabled_for_deployment          = lookup(var.key_vault[count.index], "enabled_for_deployment")
  enabled_for_disk_encryption     = lookup(var.key_vault[count.index], "enabled_for_disk_encryption")
  enabled_for_template_deployment = lookup(var.key_vault[count.index], "enabled_for_template_deployment")
  public_network_access_enabled   = lookup(var.key_vault[count.index], "public_network_access_enabled")
  purge_protection_enabled        = lookup(var.key_vault[count.index], "purge_protection_enabled")
  soft_delete_retention_days      = lookup(var.key_vault[count.index], "soft_delete_retention_days")
  tags                            = merge(var.tags, lookup(var.key_vault[count.index], "tags"))

  dynamic "access_policy" {
    for_each = lookup(var.key_vault[count.index], "access_policy") == null ? [] : ["access_policy"]
    content {
      tenant_id               = data.azurerm_client_config.this.tenant_id
      object_id               = data.azurerm_client_config.this.object_id
      application_id          = lookup(access_policy.value, "application_id")
      certificate_permissions = lookup(access_policy.value, "certificate_permissions")
      key_permissions         = lookup(access_policy.value, "key_permissions")
      secret_permissions      = lookup(access_policy.value, "secret_permissions")
      storage_permissions     = lookup(access_policy.value, "storage_permissions")
    }
  }

  dynamic "contact" {
    for_each = lookup(var.key_vault[count.index], "contact") == null ? [] : ["contact"]
    content {
      email = lookup(contact.value, "email")
      name  = lookup(contact.value, "name")
      phone = lookup(contact.value, "phone")
    }
  }

  dynamic "network_acls" {
    for_each = lookup(var.key_vault[count.index], "network_acls") == null ? [] : ["network_acls"]
    content {
      bypass                     = lookup(network_acls.value, "bypass")
      default_action             = lookup(network_acls.value, "default_action")
      ip_rules                   = lookup(network_acls.value, "ip_rules")
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids")
    }
  }
}

resource "azurerm_key_vault_access_policy" "this" {
  count                   = length(var.key_vault) == 0 ? 0 : length(var.access_policy)
  key_vault_id            = try(element(azurerm_key_vault.this.*.id, lookup(var.access_policy[count.index], "key_vault_id")))
  object_id               = data.azuread_service_principal.this.object_id
  tenant_id               = data.azurerm_client_config.this.tenant_id
  application_id          = lookup(var.access_policy[count.index], "application_id")
  certificate_permissions = lookup(var.access_policy[count.index], "certificate_permissions")
  key_permissions         = lookup(var.access_policy[count.index], "key_permissions")
  secret_permissions      = lookup(var.access_policy[count.index], "secret_permissions")
  storage_permissions     = lookup(var.access_policy[count.index], "storage_permissions")
}

resource "azurerm_key_vault_certificate" "this" {
  count        = length(var.key_vault) == 0 ? 0 : length(var.certificate)
  key_vault_id = try(element(azurerm_key_vault.this.*.id, lookup(var.certificate[count.index], "key_vault_id")))
  name         = lookup(var.certificate[count.index], "name")
  tags         = merge(var.tags, lookup(var.certificate[count.index], "tags"))

  dynamic "certificate" {
    for_each = lookup(var.certificate[count.index], "certificate") == null ? [] : ["certificate"]
    content {
      contents = file(join("/", [path.cwd, "certificate", lookup(certificate.value, "contents")]))
      password = sensitive(lookup(certificate.value, "password"))
    }
  }

  dynamic "certificate_policy" {
    for_each = lookup(var.certificate[count.index], "certificate_policy") == null ? [] : ["certificate_policy"]
    content {
      dynamic "issuer_parameters" {
        for_each = lookup(certificate_policy.value, "issuer_parameters_name") != null ? ["issuer_parameters"] : []
        content {
          name = lookup(certificate_policy.value, "issuer_parameters_name")
        }
      }

      dynamic "key_properties" {
        for_each = lookup(certificate_policy.value, "key_properties")
        content {
          key_type   = lookup(key_properties.value, "key_type")
          reuse_key  = lookup(key_properties.value, "reuse_key")
          exportable = lookup(key_properties.value, "exportable")
          key_size   = lookup(key_properties.value, "key_size")
          curve      = lookup(key_properties.value, "curve")
        }
      }

      dynamic "lifetime_action" {
        for_each = lookup(certificate_policy.value, "lifetime_action")
        content {
          dynamic "action" {
            for_each = lookup(lifetime_action.value, "action_type") != null ? ["action"] : []
            content {
              action_type = lookup(lifetime_action.value, "action_type")
            }
          }

          dynamic "trigger" {
            for_each = (lookup(lifetime_action.value, "trigger_days_before_expiry") || lookup(lifetime_action.value, "trigger_lifetime_percentage")) != null ? ["trigger"] : []
            content {
              days_before_expiry  = lookup(lifetime_action.value, "trigger_days_before_expiry")
              lifetime_percentage = lookup(lifetime_action.value, "trigger_lifetime_percentage")
            }
          }
        }
      }

      dynamic "secret_properties" {
        for_each = lookup(certificate_policy.value, "secret_properties_content_type") != null ? ["secret_properties"] : []
        content {
          content_type = lookup(certificate_policy.value, "secret_properties_content_type")
        }
      }

      dynamic "x509_certificate_properties" {
        for_each = lookup(certificate_policy.value, "x509_certificate_properties")
        content {
          key_usage          = lookup(x509_certificate_properties.value, "key_usage")
          validity_in_months = lookup(x509_certificate_properties.value, "validity_in_months")
          subject            = lookup(x509_certificate_properties.value, "subject")
          extended_key_usage = lookup(x509_certificate_properties.value, "extended_key_usage")

          dynamic "subject_alternative_names" {
            for_each = lookup(x509_certificate_properties.value, "subject_alternative_names") == null ? [] : ["subject_alternative_names"]
            content {
              dns_names = lookup(subject_alternative_names.value, "dns_names")
              emails    = lookup(subject_alternative_names.value, "emails")
              upns      = lookup(subject_alternative_names.value, "upns")
            }
          }
        }
      }
    }
  }
}

resource "azurerm_key_vault_certificate_contacts" "this" {
  count        = length(var.key_vault) == 0 ? 0 : length(var.certificate_contacts)
  key_vault_id = try(element(azurerm_key_vault.this.*.id, lookup(var.certificate_contacts[count.index], "key_vault_id")))

  dynamic "contact" {
    for_each = lookup(var.certificate_contacts[count.index], "contact")
    content {
      email = lookup(contact.value, "email")
      name  = lookup(contact.value, "name")
      phone = lookup(contact.value, "phone")
    }
  }
}

resource "azurerm_key_vault_certificate_issuer" "this" {
  count         = length(var.key_vault) == 0 ? 0 : length(var.certificate_issuer)
  key_vault_id  = try(element(azurerm_key_vault.this.*.id, lookup(var.certificate_issuer[count.index], "key_vault_id")))
  name          = lookup(var.certificate_issuer[count.index], "name")
  provider_name = lookup(var.certificate_issuer[count.index], "provider_name")
  org_id        = lookup(var.certificate_issuer[count.index], "org_id")
  account_id    = lookup(var.certificate_issuer[count.index], "account_id")
  password      = lookup(var.certificate_issuer[count.index], "password")

  dynamic "admin" {
    for_each = lookup(var.certificate_issuer[count.index], "admin") == null ? [] : ["admin"]
    content {
      email_address = lookup(admin.value, "email_address")
      first_name    = lookup(admin.value, "first_name")
      last_name     = lookup(admin.value, "last_name")
      phone         = lookup(admin.value, "phone")
    }
  }
}

resource "azurerm_key_vault_key" "this" {
  count           = length(var.key_vault) == 0 ? 0 : length(var.key_vault_key)
  key_opts        = lookup(var.key_vault_key[count.index], "key_opts")
  key_type        = lookup(var.key_vault_key[count.index], "key_type")
  key_vault_id    = try(element(azurerm_key_vault.this.*.id, lookup(var.key_vault_key[count.index], "key_vault_id")))
  name            = lookup(var.key_vault_key[count.index], "name")
  key_size        = lookup(var.key_vault_key[count.index], "key_size")
  curve           = lookup(var.key_vault_key[count.index], "curve")
  not_before_date = lookup(var.key_vault_key[count.index], "not_before_date")
  expiration_date = lookup(var.key_vault_key[count.index], "expiration_date")
  tags            = merge(var.tags, lookup(var.key_vault_key[count.index], "tags"))

  dynamic "rotation_policy" {
    for_each = lookup(var.key_vault_key[count.index], "rotation_policy") == null ? [] : ["rotation_policy"]
    content {
      expire_after         = lookup(rotation_policy.value, "expire_after")
      notify_before_expiry = lookup(rotation_policy.value, "notify_before_expiry")

      dynamic "automatic" {
        for_each = lookup(rotation_policy.value, "automatic") == null ? [] : ["automatic"]
        content {
          time_after_creation = lookup(automatic.value, "time_after_creation")
          time_before_expiry  = lookup(automatic.value, "time_before_expiry")
        }
      }
    }
  }
}

resource "azurerm_key_vault_managed_hardware_security_module" "this" {
  count                                     = length(var.managed_hardware_security_module)
  admin_object_ids                          = [data.azurerm_client_config.this.object_id]
  location                                  = data.azurerm_resource_group.this.location
  name                                      = lookup(var.managed_hardware_security_module[count.index], "name")
  resource_group_name                       = data.azurerm_resource_group.this.name
  sku_name                                  = lookup(var.managed_hardware_security_module[count.index], "sku_name", "Standard_B1")
  tenant_id                                 = data.azurerm_client_config.this.tenant_id
  purge_protection_enabled                  = lookup(var.managed_hardware_security_module[count.index], "purge_protection_enabled")
  soft_delete_retention_days                = lookup(var.managed_hardware_security_module[count.index], "soft_delete_retention_days")
  public_network_access_enabled             = lookup(var.managed_hardware_security_module[count.index], "public_network_access_enabled")
  security_domain_key_vault_certificate_ids = lookup(var.managed_hardware_security_module[count.index], "security_domain_key_vault_certificate_ids")
  security_domain_quorum                    = lookup(var.managed_hardware_security_module[count.index], "security_domain_quorum")
  tags                                      = merge(var.tags, lookup(var.managed_hardware_security_module[count.index], "tags"))

  dynamic "network_acls" {
    for_each = (lookup(var.managed_hardware_security_module[count.index], "network_acls_bypass") && lookup(var.managed_hardware_security_module[count.index], "network_acls_default_action")) != null ? ["network_acls"] : []
    content {
      bypass         = lookup(var.managed_hardware_security_module[count.index], "network_acls_bypass")
      default_action = lookup(var.managed_hardware_security_module[count.index], "network_acls_default_action")
    }
  }
}

resource "azurerm_key_vault_managed_hardware_security_module_key" "this" {
  count           = length(var.managed_hardware_security_module_key)
  name            = lookup(var.managed_hardware_security_module_key[count.index], "name")
  key_opts        = lookup(var.managed_hardware_security_module_key[count.index], "key_opts")
  key_type        = lookup(var.managed_hardware_security_module_key[count.index], "key_type")
  managed_hsm_id  = try(element(azurerm_key_vault_managed_hardware_security_module.this.*.id, lookup(var.managed_hardware_security_module_key[count.index], "managed_hsm_id")))
  curve           = lookup(var.managed_hardware_security_module_key[count.index], "curve")
  expiration_date = lookup(var.managed_hardware_security_module_key[count.index], "expiration_date")
  key_size        = lookup(var.managed_hardware_security_module_key[count.index], "key_size")
  not_before_date = lookup(var.managed_hardware_security_module_key[count.index], "not_before_date")
  tags            = merge(var.tags, lookup(var.managed_hardware_security_module_key[count.index], "tags"))
}

resource "azurerm_key_vault_managed_hardware_security_module_role_definition" "this" {
  count          = length(var.managed_hardware_security_module_role_definition)
  name           = lookup(var.managed_hardware_security_module_role_definition[count.index], "name")
  vault_base_url = try(element(azurerm_key_vault_managed_hardware_security_module.this.hsm_uri, lookup(var.managed_hardware_security_module_role_definition[count.index], "vault_base_id")))
  description    = lookup(var.managed_hardware_security_module_role_definition[count.index], "description")
  role_name      = lookup(var.managed_hardware_security_module_role_definition[count.index], "role_name")

  dynamic "permission" {
    for_each = lookup(var.managed_hardware_security_module_role_definition[count.index], "permission") == null ? [] : ["permission"]
    content {
      actions          = lookup(permission.value, "actions")
      not_actions      = lookup(permission.value, "not_actions")
      data_actions     = lookup(permission.value, "data_actions")
      not_data_actions = lookup(permission.value, "not_data_actions")
    }
  }
}

resource "azurerm_key_vault_managed_hardware_security_module_role_assignment" "this" {
  count              = (length(var.managed_hardware_security_module_role_definition) && length(var.managed_hardware_security_module)) == 0 ? 0 : length(var.managed_hardware_security_module_role_assignment)
  managed_hsm_id     = try(element(azurerm_key_vault_managed_hardware_security_module.this.*.id, lookup(var.managed_hardware_security_module_role_assignment[count.index], "managed_hsm_id")))
  name               = lookup(var.managed_hardware_security_module_role_assignment[count.index], "name")
  principal_id       = data.azurerm_client_config.this.object_id
  role_definition_id = try(element(data.azurerm_key_vault_managed_hardware_security_module_role_definition.this.*.resource_id, lookup(var.managed_hardware_security_module_role_assignment[count.index], "role_definition_id")))
  scope              = try(element(data.azurerm_key_vault_managed_hardware_security_module_role_definition.this.*.scope, lookup(var.managed_hardware_security_module_role_assignment[count.index], "role_definition_id")))
}

resource "azurerm_key_vault_managed_storage_account" "this" {
  count                        = (length(var.key_vault) && length(var.storage_account)) == 0 ? 0 : length(var.managed_storage_account)
  key_vault_id                 = try(element(azurerm_key_vault.this.*.id, lookup(var.managed_storage_account[count.index], "key_vault_id")))
  name                         = lookup(var.managed_storage_account[count.index], "name")
  storage_account_id           = try(element(module.storage.*.storage_account_id, lookup(var.managed_storage_account[count.index], "storage_account_id")))
  storage_account_key          = lookup(var.managed_storage_account[count.index], "storage_account_key")
  regenerate_key_automatically = lookup(var.managed_storage_account[count.index], "regenerate_key_automatically")
  regeneration_period          = lookup(var.managed_storage_account[count.index], "regeneration_period")
  tags                         = merge(var.tags, lookup(var.managed_storage_account[count.index], "tags"))
}

resource "azurerm_key_vault_managed_storage_account_sas_token_definition" "this" {
  count                      = length(var.managed_storage_account) == 0 ? 0 : length(var.managed_storage_account_sas_token_definition)
  managed_storage_account_id = try(element(azurerm_key_vault_managed_storage_account.this.*.id, lookup(var.managed_storage_account_sas_token_definition[count.index], "managed_storage_account_id")))
  name                       = lookup(var.managed_storage_account_sas_token_definition[count.index], "name")
  sas_template_uri           = try(element(module.storage.*.storage_account_id, lookup(var.managed_storage_account_sas_token_definition[count.index], "sas_template_id")))
  sas_type                   = lookup(var.managed_storage_account_sas_token_definition[count.index], "sas_type")
  validity_period            = lookup(var.managed_storage_account_sas_token_definition[count.index], "validity_period")
  tags                       = merge(var.tags, lookup(var.managed_storage_account_sas_token_definition[count.index], "tags"))
}

resource "azurerm_key_vault_secret" "this" {
  count           = length(var.secret)
  key_vault_id    = try(element(azurerm_key_vault.this.*.id, lookup(var.secret[count.index], "key_vault_id")))
  name            = lookup(var.secret[count.index], "name")
  value           = lookup(var.secret[count.index], "value")
  content_type    = lookup(var.secret[count.index], "content_type")
  not_before_date = lookup(var.secret[count.index], "not_before_date")
  expiration_date = lookup(var.secret[count.index], "expiration_date")
  tags            = merge(var.tags, lookup(var.secret[count.index], "tags"))
}