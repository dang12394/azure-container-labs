resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "dang12394-mysql"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "azuremysql"
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1ms"
  storage {
    size_gb = 32
    io_scaling_enabled = true
    auto_grow_enabled = false
  }
  zone = "2"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysql" {
  name                = "AzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_flexible_database" "mysql" {
  name = "azurevote"
  resource_group_name = azurerm_resource_group.rg.name
  server_name = azurerm_mysql_flexible_server.mysql.name
  charset = "utf8"
  collation = "utf8_unicode_ci"
}