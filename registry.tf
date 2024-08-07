resource "azurerm_container_registry" "acr" {
  name = "dang12394"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku = "Standard"
  admin_enabled = true
}

resource "null_resource" "acr_build" {
  provisioner "local-exec" {
    command = <<EOT
      az login --service-principal -u ${var.client_id} -p ${var.client_secret} --tenant ${var.tenant_id}
      az acr build --registry ${azurerm_container_registry.acr.name} --image azure-vote:1.0 ./apps/vote/azure-vote
    EOT

    environment = {
      AZURE_CLIENT_ID     = var.client_id
      AZURE_CLIENT_SECRET = var.client_secret
      AZURE_TENANT_ID     = var.tenant_id
      AZURE_SUBSCRIPTION_ID = var.subscription_id
    }
  }
}