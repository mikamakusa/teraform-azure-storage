data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azuread_service_principal" "this" {}

data "azurerm_virtual_network" "this" {
  count               = var.virtual_network_name ? 1 : 0
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_subnet" "this" {
  count                = var.subnet_name ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = data.azurerm_virtual_network.this.name
}

data "azurerm_network_interface" "this" {
  count               = var.network_interface_name ? 1 : 0
  name                = var.network_interface_name
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_virtual_machine" "this" {
  count               = var.virtual_machine_name ? 1 : 0
  name                = var.virtual_machine_name
  resource_group_name = data.azurerm_resource_group.this.name
}