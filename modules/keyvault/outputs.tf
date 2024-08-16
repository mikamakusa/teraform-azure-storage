## KEY VAULT ##

output "key_vault_id" {
  value = try(
    azurerm_key_vault.this.*.id
  )
}

## KEY VAULT ACCESS POLICY ##

output "key_vault_access_policy_id" {
  value = try(
    azurerm_key_vault_access_policy.this.*.id
  )
}

## CERTIFICATE ##

output "certificate_id" {
  value = try(
    azurerm_key_vault_certificate.this.*.id
  )
}

output "certificate_name" {
  value = try(
    azurerm_key_vault_certificate.this.*.name
  )
}

output "certificate_issuer_id" {
  value = try(
    azurerm_key_vault_certificate_issuer.this.*.id
  )
}

output "certificate_issuer_name" {
  value = try(
    azurerm_key_vault_certificate_issuer.this.*.name
  )
}

output "certificate_contacts_id" {
  value = try(
    azurerm_key_vault_certificate_contacts.this.*.id
  )
}

## KEY VAULT KEY

output "key_vault_key_id" {
  value = try(
    azurerm_key_vault_key.this.*.id
  )
}

output "key_vault_key_name" {
  value = try(
    azurerm_key_vault_key.this.*.name
  )
}

## MANAGED HSM ##

output "managed_hsm_id" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module.this.*.id
  )
}

output "managed_hsm_name" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module.this.*.name
  )
}

output "managed_hsm_key_id" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module_key.this.*.id
  )
}

output "managed_hsm_key_name" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module_key.this.*.name
  )
}

output "managed_hsm_role_assignment_id" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module_role_assignment.this.*.id
  )
}

output "managed_hsm_role_assignment_name" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module_role_assignment.this.*.name
  )
}

output "managed_hsm_role_defintion_id" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module_role_definition.this.*.id
  )
}

output "managed_hsm_role_defintion_name" {
  value = try(
    azurerm_key_vault_managed_hardware_security_module_role_definition.this.*.name
  )
}

## MANAGED STORAGE ACCOUNT ##

output "managed_storage_account_id" {
  value = try(
    azurerm_key_vault_managed_storage_account.this.*.id
  )
}

output "managed_storage_account_name" {
  value = try(
    azurerm_key_vault_managed_storage_account.this.*.name
  )
}

output "managed_storage_account_sas_token_definition_id" {
  value = try(
    azurerm_key_vault_managed_storage_account_sas_token_definition.this.*.id
  )
}

output "managed_storage_account_sas_token_definition_name" {
  value = try(
    azurerm_key_vault_managed_storage_account_sas_token_definition.this.*.name
  )
}

## SECRET ##

output "secret_id" {
  value = try(
    azurerm_key_vault_secret.this.id
  )
}

output "secret_name" {
  value = try(
    azurerm_key_vault_secret.this.*.name
  )
}

output "secret_value" {
  value = try(
    azurerm_key_vault_secret.this.*.value
  )
}

output "secret_version" {
  value = try(
    azurerm_key_vault_secret.this.*.version
  )
}