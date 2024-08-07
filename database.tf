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
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysql" {
  name                = "AzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysl.name
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

resource "null_resource" "create_table" {
  depends_on = [azurerm_mysql_flexible_database.mysql]

  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${azurerm_mysql_flexible_server.mysql.fqdn} -u ${azurerm_mysql_flexible_server.mysql.administrator_login}@${azurerm_mysql_flexible_server.mysql.name} -p ${azurerm_mysql_flexible_server.mysql.administrator_password} -e "CREATE TABLE ${azurerm_mysql_flexible_database.mysql.name}.azurevote (voteid INT NOT NULL AUTO_INCREMENT,votevalue VARCHAR(45) NULL,PRIMARY KEY (voteid));"
    EOT
  }
}