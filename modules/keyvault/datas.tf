data "azurerm_client_config" "this" {}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azuread_service_principal" "this" {}

data "azurerm_key_vault_managed_hardware_security_module" "this" {
  count               = length(var.managed_hardware_security_module)
  name                = lookup(var.managed_hardware_security_module[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_key_vault_managed_hardware_security_module_role_definition" "this" {
  count = length(var.managed_hardware_security_module_role_definition)
  name  = lookup(var.managed_hardware_security_module_role_definition[count.index], "name")
}

data "azurerm_storage_account" "this" {
  count               = length(var.storage_account)
  name                = lookup(var.storage_account[count.index], "name")
  resource_group_name = data.azurerm_resource_group.this.name
}