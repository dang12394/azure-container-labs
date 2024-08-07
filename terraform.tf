terraform { 
  cloud { 
    
    organization = "dang12394" 

    workspaces { 
      name = "Project_Container" 
    } 
  } 
  required_providers {
    azurerm ={
        source = "hashicorp/azurerm"
        version ="3.114.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "Container_App"
  location = "eastasia"
}