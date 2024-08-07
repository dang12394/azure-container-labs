resource "azurerm_service_plan" "app" {
  name = "dang12394-linux"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  os_type = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "app" {
  name = "container12394"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  service_plan_id = azurerm_service_plan.app.id
  site_config {
    always_on = false
    application_stack {
      docker_image_name = "${azurerm_container_registry.acr.login_server}/azure-vote:1.0"
      docker_registry_url = azurerm_container_registry.acr.login_server
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
  }
  app_settings = {
    MYSQL_USER = azurerm_mysql_flexible_server.mysql.administrator_login
    MYSQL_PASSWORD = azurerm_mysql_flexible_server.mysql.administrator_password
    MYSQL_HOST= azurerm_mysql_flexible_server.mysql.fqdn
    MYSQL_DATABASE= azurerm_mysql_flexible_database.mysql.name
  }
}
