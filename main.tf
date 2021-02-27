terraform {
  required_providers {
  azurerm = {
    source      = "hashicorp/azurerm"
    version     = "=2.41.0"
    }
  }
  backend "azurerm" {
resource_group_name      = "terraform-dp"
storage_account_name     = "dataplugin"
container_name           = "dpstate"
key                      = "snapshotest.tfstate"
  }
}
provider "azurerm" {
  features {}
}
data "azurerm_resource_group" "example" {
  name     = "hub-aks"
}
module "vnet" {
  source              = "git::https://github.com/gokala/terraformsnap/tree/main/Modules/Vnet.git"
  resourcegroup       = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  vnet_name           = "dataplugin-vnet11"
  #address_space       = ["192.168.0.0/16"]
  #subnet_prefixes     = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  address_space      = ["192.168.4.0/24"]
  subnet_prefixes    = ["192.168.4.0/24"]
  #subnet_names        = ["web", "app", "db"]
  subnet_names       = ["app"]

    depends_on = [data.azurerm_resource_group.example]
        }
  /*
  module "app-vms" {
  source              = ".//modules/Virtual_Machine"
  snapshot            ="DatapluginVM"
  vm_size             ="Standard_B2s"
  vmrg                =data.azurerm_resource_group.example.name
  location            =data.azurerm_resource_group.example.location
  vnet_subnet_id      =module.vnet.vnet_subnets[0]
  vm_hostname         ="dataplugin-snap01"
  vnet                =module.vnet.vnet_address_space
  vm_os_publisher     ="RedHat"
  vm_os_offer         ="RHEL"
  vm_os_sku           ="7.4"
  vm_os_version       ="latest"
  }  
  */
 module "Cloudera" {
  source              = "git::https://github.com/gokala/terraformsnap/tree/main/Modules/Virtual_Machine.git"
  OS-snapshot            ="cloudera"
  datadisk0-snapshot  ="app01"
  #datadisk1-snapshot
  vm_size             ="Standard_B4ms"
  vmrg                =data.azurerm_resource_group.example.name
  location            =data.azurerm_resource_group.example.location
  vnet_subnet_id      =module.vnet.vnet_subnets[0]
  vm_hostname         ="Cloudera-snap01"
  vnet                =module.vnet.vnet_address_space
  vm_os_publisher     ="RedHat"
  vm_os_offer         ="RHEL"
  vm_os_sku           ="7.4"
  vm_os_version       ="latest"
  }
  /*
  module "HDP" {
  source              = ".//modules/Virtual_Machine"
  snapshot            ="HDPVM"
  vm_size             ="Standard_D4s_v3"
  vmrg                =data.azurerm_resource_group.example.name
  location            =data.azurerm_resource_group.example.location
  vnet_subnet_id      =module.vnet.vnet_subnets[0]
  vm_hostname         ="HDP-snap01"
  vnet                =module.vnet.vnet_address_space
  vm_os_publisher     ="RedHat"
  vm_os_offer         ="RHEL"
  vm_os_sku           ="7.4"
  vm_os_version       ="latest"
  }
  */
