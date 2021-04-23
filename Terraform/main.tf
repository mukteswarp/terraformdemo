terraform{
    backend "azurerm"{
        storage_account_name = "_tfstorageaccnt_"
        container_name = "terraform"
        key = "terraform.tfstate"
        access_key = "_storagekey_"
        }
    }
#terraform {
#    required_version = ">= 0.11" 
#    backend "azurerm" {
#    storage_account_name = "_tfstorageaccnt_"
#    container_name       = "terraform"
#    key                  = "terraform.tfstate"
#    access_key  ="__storagekey__"
#    features{}
#    }
#}

# above added
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "myterraformgroup" {
    name     = "_tfstorageresrcgrp_"
    # "myTFResourceGroup"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}

#resource "random_id" "randomId" {
#    keepers = {
#        # Generate a new ID only when a new resource group is defined
#        resource_group = azurerm_resource_group.myterraformgroup.name
#    }
#
#    byte_length = 8
#}

resource "azurerm_storage_account" "mystorageaccount" {
#    name                        = "diag${random_id.randomId.hex}"
    name                        = "_tfstorageaccnt_"
    # "tfstorageaccount"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    location                    = "eastus"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_storage_container" "mystoragecontainer" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.mystorageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "myblobstorage" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.mystorageaccount.name
  storage_container_name = azurerm_storage_container.mystoragecontainer.name
  type                   = "Block"
  source                 = "some-local-file.zip"
}
