module "key_vault" {
  source              = "./modules/terraform-azure-keyvault"
  key_vault           = var.keyvault
  key_vault_key       = var.keyvault_key
  resource_group_name = data.azurerm_resource_group.this.name
}