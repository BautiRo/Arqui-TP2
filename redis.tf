resource "azurerm_redis_cache" "redis" {
  name                = "redis-arquincho-cache"
  location            = azurerm_resource_group.tp2_resource_group.location
  resource_group_name = azurerm_resource_group.tp2_resource_group.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = true

  # Store hostname
  provisioner "local-exec" {
    command = "echo -n ${azurerm_redis_cache.redis.hostname} > hostname"
  }

  # Use the redis server hostname in node
  provisioner "local-exec" {
    command = "sed -Ei.bak \"s/(host:)[^,]*,/\\1 '$(cat hostname)',/\" node/config.js"
  }
}