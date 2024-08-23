## ACCOUNT ##

output "storage_account_id" {
  value = try(
    azurerm_storage_account.this.*.id
  )
}

output "storage_account_name" {
  value = try(
    azurerm_storage_account.this.*.name
  )
}

output "storage_account_primary_connection_string" {
  value = try(
    azurerm_storage_account.this.*.primary_connection_string
  )
}

output "storage_account_primary_blob_connection_string" {
  value = try(
    azurerm_storage_account.this.*.primary_blob_connection_string
  )
}

## HPC CACHE ##

output "hpc_cache_id" {
  value = try(
    azurerm_hpc_cache.this.*.id
  )
}

output "hpc_cache_name" {
  value = try(
    azurerm_hpc_cache.this.*.name
  )
}

output "hpc_cache_sku_name" {
  value = try(
    azurerm_hpc_cache.this.*.sku_name
  )
}

## HPC CACHE ACCESS POLICY ##

output "hpc_cache_access_policy_id" {
  value = try(
    azurerm_hpc_cache_access_policy.this.*.id
  )
}

output "hpc_cache_access_policy_name" {
  value = try(
    azurerm_hpc_cache_access_policy.this.*.name
  )
}

## HPC CACHE BLOB NFS TARGET ##

output "hpc_cache_blob_nfs_target_name" {
  value = try(
    azurerm_hpc_cache_blob_nfs_target.this.*.name
  )
}

output "hpc_cache_blob_nfs_target_id" {
  value = try(
    azurerm_hpc_cache_blob_nfs_target.this.*.id
  )
}

## HPC CACHE BLOB TARGET ##

output "hpc_cache_blob_target_name" {
  value = try(
    azurerm_hpc_cache_blob_target.this.*.name
  )
}

output "hpc_cache_blob_target_id" {
  value = try(
    azurerm_hpc_cache_blob_target.this.*.id
  )
}

## HPC CACHE NFS TARGET ##

output "hpc_cache_nfs_target_name" {
  value = try(
    azurerm_hpc_cache_nfs_target.this.*.name
  )
}

output "hpc_cache_nfs_target_id" {
  value = try(
    azurerm_hpc_cache_nfs_target.this.*.id
  )
}

## CUSTOMER MANAGED KEY ##

output "customer_manager_key_id" {
  value = try(
    azurerm_storage_account_customer_managed_key.this.*.id
  )
}

output "customer_manager_key_storage_account_id" {
  value = try(
    azurerm_storage_account_customer_managed_key.this.*.storage_account_id
  )
}

output "customer_manager_key_vault_id" {
  value = try(
    azurerm_storage_account_customer_managed_key.this.*.key_vault_id
  )
}

## CONTAINER ##

output "container_name" {
  value = try(
    azurerm_storage_container.this.*.name
  )
}

output "container_id" {
  value = try(
    azurerm_storage_container.this.*.id
  )
}