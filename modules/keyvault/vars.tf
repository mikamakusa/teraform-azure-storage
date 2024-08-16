##TAGS ##

variable "tags" {
  type    = map(string)
  default = {}
}

## DATAS ##

variable "resource_group_name" {
  type = string
}

## MODULES ##

variable "storage_account" {
  type    = any
  default = []
}

## RESOURCES ##

variable "key_vault" {
  type = list(object({
    id                              = number
    name                            = string
    sku_name                        = string
    enable_rbac_authorization       = optional(bool)
    enabled_for_deployment          = optional(bool)
    enabled_for_disk_encryption     = optional(bool)
    enabled_for_template_deployment = optional(bool)
    public_network_access_enabled   = optional(bool)
    purge_protection_enabled        = optional(bool)
    soft_delete_retention_days      = optional(number)
    tags                            = optional(map(string))
    access_policy = optional(list(object({
      application_id          = optional(string)
      certificate_permissions = optional(list(string))
      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      storage_permissions     = optional(list(string))
    })))
    contact = optional(list(object({
      email = string
      name  = optional(string)
      phone = optional(string)
    })))
    network_acls = optional(list(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.key_vault : true if a.soft_delete_retention_days >= 7 && a.soft_delete_retention_days <= 90
    ]) == length(var.key_vault)
    error_message = "This value can be between 7 and 90 (the default) days."
  }

  validation {
    condition = length([
      for b in var.key_vault : true if contains(["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"], b.access_policy.certificate_permissions)
    ]) == length(var.key_vault)
    error_message = "List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update."
  }

  validation {
    condition = length([
      for c in var.key_vault : true if contains(["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"], c.access_policy.key_permissions)
    ]) == length(var.key_vault)
    error_message = "List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy and SetRotationPolicy."
  }

  validation {
    condition = length([
      for d in var.key_vault : true if contains(["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"], d.access_policy.secret_permissions)
    ]) == length(var.key_vault)
    error_message = "List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set."
  }

  validation {
    condition = length([
      for e in var.key_vault : true if contains(["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"], e.access_policy.storage_permissions)
    ]) == length(var.key_vault)
    error_message = "List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update."
  }

  validation {
    condition = length([
      for f in var.key_vault : true if contains(["AzureServices", "None"], f.network_acls.bypass)
    ]) == length(var.key_vault)
    error_message = "Possible values are AzureServices and None."
  }

  validation {
    condition = length([
      for g in var.key_vault : true if contains(["Allow", "Deny"], g.network_acls.default_action)
    ]) == length(var.key_vault)
    error_message = "Possible values are Allow and Deny."
  }
}

variable "access_policy" {
  type = list(object({
    id                      = number
    key_vault_id            = any
    application_id          = optional(string)
    certificate_permissions = optional(list(string))
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    storage_permissions     = optional(list(string))
  }))
  default = []

  validation {
    condition = length([
      for a in var.access_policy : true if contains(["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"], a.certificate_permissions)
    ]) == length(var.access_policy)
    error_message = "List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update."
  }

  validation {
    condition = length([
      for b in var.access_policy : true if contains(["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"], b.key_permissions)
    ]) == length(var.access_policy)
    error_message = "List of key permissions, must be one or more from the following: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy and SetRotationPolicy."
  }

  validation {
    condition = length([
      for c in var.access_policy : true if contains(["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"], c.secret_permissions)
    ]) == length(var.access_policy)
    error_message = "List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set."
  }

  validation {
    condition = length([
      for c in var.access_policy : true if contains(["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"], c.secret_permissions)
    ]) == length(var.access_policy)
    error_message = "List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update."
  }
}

variable "certificate" {
  type = list(object({
    id           = number
    key_vault_id = any
    name         = string
    tags         = optional(map(string))
    certificate = optional(list(object({
      contents = string
      password = optional(string)
    })))
    certificate_policy = optional(list(object({
      issuer_parameters_name = string
      key_properties = list(object({
        key_type   = string
        reuse_key  = bool
        exportable = bool
        key_size   = optional(number)
        curve      = optional(string)
      }))
      lifetime_action = list(object({
        action_type                 = string
        trigger_days_before_expiry  = optional(number)
        trigger_lifetime_percentage = optional(number)
      }))
      secret_properties_content_type = string
      x509_certificate_properties = optional(list(object({
        key_usage          = list(string)
        validity_in_months = number
        subject            = string
        extended_key_usage = optional(list(string))
        subject_alternative_names = optional(list(object({
          dns_names = optional(list(string))
          emails    = optional(list(string))
          upns      = optional(list(string))
        })))
      })))
    })))
  }))
  default = []
}

variable "certificate_contacts" {
  type = list(object({
    id           = number
    key_vault_id = any
    contact = list(object({
      email = string
      name  = optional(string)
      phone = optional(string)
    }))
  }))
  default = []
}

variable "certificate_issuer" {
  type = list(object({
    id            = number
    key_vault_id  = any
    name          = string
    provider_name = string
    org_id        = optional(string)
    account_id    = optional(string)
    password      = optional(string)
    admin = optional(list(object({
      email_address = string
      first_name    = optional(string)
      last_name     = optional(string)
      phone         = optional(string)
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.certificate_issuer : true if contains(["DigiCert", "GlobalSign", "OneCertV2-PrivateCA", "OneCertV2-PublicCA", "SslAdminV2"], a.provider_name)
    ]) == length(var.certificate_issuer)
    error_message = "Possible values are: DigiCert, GlobalSign, OneCertV2-PrivateCA, OneCertV2-PublicCA and SslAdminV2."
  }
}

variable "key_vault_key" {
  type = list(object({
    id              = number
    key_opts        = list(string)
    key_type        = string
    key_vault_id    = any
    name            = string
    key_size        = optional(number)
    curve           = optional(string)
    not_before_date = optional(string)
    expiration_date = optional(string)
    tags            = optional(map(string))
    rotation_policy = optional(list(object({
      expire_after         = optional(string)
      notify_before_expiry = optional(string)
      automatic = optional(list(object({
        time_after_creation = optional(string)
        time_before_expiry  = optional(string)
      })))
    })))
  }))
  default = []

  validation {
    condition = length([
      for a in var.key_vault_key : true if contains(["EC", "EC-HSM", "RSA", "RSA-HSM"], a.key_type)
    ]) == length(var.key_vault_key)
    error_message = "Possible values are EC (Elliptic Curve), EC-HSM, RSA and RSA-HSM."
  }

  validation {
    condition = length([
      for b in var.key_vault_key : true if contains(["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"], b.key_opts)
    ]) == length(var.key_vault_key)
    error_message = "Possible values include: decrypt, encrypt, sign, unwrapKey, verify and wrapKey."
  }

  validation {
    condition = length([
      for c in var.key_vault_key : true if contains(["P-256", "P-256K", "P-384", "P-521"], c.curve)
    ]) == length(var.key_vault_key)
    error_message = "Possible values are P-256, P-256K, P-384, and P-521."
  }
}

variable "managed_hardware_security_module" {
  type = list(object({
    id                                        = number
    name                                      = string
    sku_name                                  = string
    purge_protection_enabled                  = optional(bool)
    soft_delete_retention_days                = optional(number)
    public_network_access_enabled             = optional(bool)
    security_domain_key_vault_certificate_ids = optional(list(string))
    security_domain_quorum                    = optional(number)
    tags                                      = optional(map(string))
    network_acls_bypass                       = string
    network_acls_default_action               = string
  }))
  default = []

  validation {
    condition = length([
      for a in var.managed_hardware_security_module : true if a.soft_delete_retention_days >= 7 && a.soft_delete_retention_days <= 90
    ]) == length(var.managed_hardware_security_module)
    error_message = "This value can be between 7 and 90 days."
  }

  validation {
    condition = length([
      for b in var.managed_hardware_security_module : true if contains(["AzureServices", "None"], b.network_acls_bypass)
    ]) == length(var.managed_hardware_security_module)
    error_message = "Possible values are AzureServices and None."
  }

  validation {
    condition = length([
      for b in var.managed_hardware_security_module : true if contains(["Allow", "Deny"], b.network_acls_default_action)
    ]) == length(var.managed_hardware_security_module)
    error_message = "Possible values are Allow and Deny."
  }
}

variable "managed_hardware_security_module_key" {
  type = list(object({
    id              = number
    name            = string
    key_opts        = list(string)
    key_type        = string
    managed_hsm_id  = any
    curve           = optional(number)
    expiration_date = optional(string)
    key_size        = optional(number)
    not_before_date = optional(string)
    tags            = optional(map(string))
  }))
  default = []
}

variable "managed_hardware_security_module_role_definition" {
  type = list(object({
    id            = number
    name          = string
    vault_base_id = any
    description   = string
    role_name     = string
    permission = optional(list(object({
      actions          = optional(list(string))
      not_actions      = optional(list(string))
      data_actions     = optional(list(string))
      not_data_actions = optional(list(string))
    })))
  }))
  default = []
}

variable "managed_hardware_security_module_role_assignment" {
  type = list(object({
    id                 = number
    managed_hsm_id     = any
    name               = string
    role_definition_id = any
  }))
  default = []
}

variable "managed_storage_account" {
  type = list(object({
    id                           = number
    key_vault_id                 = any
    name                         = string
    storage_account_id           = any
    storage_account_key          = string
    regenerate_key_automatically = optional(bool)
    regeneration_period          = optional(string)
    tags                         = optional(map(string))
  }))
  default = []

  validation {
    condition = length([
      for a in var.managed_storage_account : true if contains(["key1", "key2"], a.storage_account_key)
    ]) == length(var.managed_storage_account)
    error_message = "Possible values are key1 and key2."
  }
}

variable "managed_storage_account_sas_token_definition" {
  type = list(object({
    id                         = number
    managed_storage_account_id = any
    name                       = string
    sas_template_id            = any
    sas_type                   = string
    validity_period            = string
    tags                       = optional(map(string))
  }))
  default = []

  validation {
    condition = length([
      for a in var.managed_storage_account_sas_token_definition : true if contains(["account", "service"], a.sas_type)
    ]) == length(var.managed_storage_account_sas_token_definition)
    error_message = "Possible values are account and service."
  }
}

variable "secret" {
  type = list(object({
    id              = number
    key_vault_id    = any
    name            = string
    value           = string
    content_type    = optional(string)
    not_before_date = optional(string)
    expiration_date = optional(string)
    tags            = optional(map(string))
  }))
  default = []
}