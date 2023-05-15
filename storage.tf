resource "azurerm_storage_account" "tp2_storage" {
  name                     = var.storage_acct_name
  resource_group_name      = azurerm_resource_group.tp2_resource_group.name
  location                 = azurerm_resource_group.tp2_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "tp2_container" {
  name                  = "src"
  storage_account_name  = azurerm_storage_account.tp2_storage.name
  container_access_type = "blob"
}

resource "time_offset" "expiry" {
  offset_days = 7
}

data "azurerm_storage_account_sas" "tp2_storage_sas" {
  connection_string = azurerm_storage_account.tp2_storage.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = time_offset.expiry.base_rfc3339
  expiry = time_offset.expiry.rfc3339

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = true
    process = false
  }
}

resource "local_file" "tp2_storage_conn_string" {
  content  = data.azurerm_storage_account_sas.tp2_storage_sas.connection_string
  filename = "${path.module}/storage_conn_string"
}