resource "azurerm_storage_blob" "function" {
  name                   = "function.zip"
  storage_account_name   = azurerm_storage_account.tp2_storage.name
  storage_container_name = azurerm_storage_container.tp2_container.name
  type                   = "Block"
  source                 = "${path.module}/python-function/function.zip"
}

data "azurerm_storage_account_blob_container_sas" "tp2_storage_container_sas" {
  connection_string = azurerm_storage_account.tp2_storage.primary_connection_string
  container_name    = azurerm_storage_container.tp2_container.name

  start  = "2022-01-01T00:00:00Z"
  expiry = "2023-01-01T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}

resource "azurerm_app_service_plan" "tp2_app_plan" {
  name                = "tp2_app_plan"
  location            = azurerm_resource_group.tp2_resource_group.location
  resource_group_name = azurerm_resource_group.tp2_resource_group.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "tp2_function_app" {
  name                       = "${var.group_prefix}"
  version                    = "~3"
  location                   = azurerm_resource_group.tp2_resource_group.location
  resource_group_name        = azurerm_resource_group.tp2_resource_group.name
  app_service_plan_id        = azurerm_app_service_plan.tp2_app_plan.id
  storage_account_name       = azurerm_storage_account.tp2_storage.name
  storage_account_access_key = azurerm_storage_account.tp2_storage.primary_access_key
  os_type                    = "linux"

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"    = "https://${azurerm_storage_account.tp2_storage.name}.blob.core.windows.net/${azurerm_storage_container.tp2_container.name}/${azurerm_storage_blob.function.name}${data.azurerm_storage_account_blob_container_sas.tp2_storage_container_sas.sas}",
    "FUNCTIONS_WORKER_RUNTIME"    = "python",
    "AzureWebJobsDisableHomepage" = "true"
  }

  site_config {
    linux_fx_version          = "python|3.6"
    use_32_bit_worker_process = false
  }

  provisioner "local-exec" {
    command = "echo ${azurerm_function_app.tp2_function_app.default_hostname} > python-function/base_url"
  }

  provisioner "local-exec" {
    command = "sed -Ei.bak \"s#(alternateUrl:)[^,]*,#\\1 'http://$(cat python-function/base_url)/api/alternate',#\" node/config.js"
  }
}
