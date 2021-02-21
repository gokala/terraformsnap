resource "azurerm_network_interface" "vm" {
  name                      ="nic-${var.vm_hostname}"
  location                  = var.location
  resource_group_name       = var.vmrg

  ip_configuration {
    name                          = "${var.vm_hostname}-ip"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id=azurerm_public_ip.plugin-PIP.id
  }
}
  resource "azurerm_public_ip" "plugin-PIP" {
  name= "${var.vm_hostname}-Pip"
  location=var.location
  resource_group_name=var.vmrg
  sku="Standard"
  allocation_method="Static"
  }

data "azurerm_snapshot" "Vm1" {
  count = "${length(var.snapshot)}"
  name=   "${var.snapshot[count.index]}"
  resource_group_name=var.vmrg
}
resource "azurerm_managed_disk" "terramformpoc" {
   count = "${length(var.snapshot)}"
   #name="disk-${var.snapshot[count.index]}"
   name="${var.vm_hostname}-${var.snapshot[count.index]}"
   resource_group_name=var.vmrg
   location=var.location
   storage_account_type = "Standard_LRS"
   create_option="Copy"
   source_resource_id="${element(data.azurerm_snapshot.Vm1.*.id,count.index)}"
   disk_size_gb="64"
}
resource "azurerm_virtual_machine" "appservers" {
  count = "${length(var.snapshot)}"
  name=var.vm_hostname
  resource_group_name=var.vmrg
  location=var.location
  vm_size = var.vm_size
  network_interface_ids=[azurerm_network_interface.vm.id]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination
  
  storage_os_disk {     
        name   = azurerm_managed_disk.terramformpoc.*.name[0]
        os_type = "Linux"
        caching="ReadWrite"
        managed_disk_id=azurerm_managed_disk.terramformpoc.*.id[0]
        create_option="attach"
    }
    dynamic "storage_data_disk" {
      for_each = var.additional_data_disk ? ["data"] : []
      content {
      name  = azurerm_managed_disk.terramformpoc.*.name[1]
      lun = "0"
      managed_disk_id=azurerm_managed_disk.terramformpoc.*.id[1]
      disk_size_gb="64"
      create_option="attach"
      }
    }
    /*dynamic "storage_data_disk" {
      for_each = var.additional_data_disk ? ["data"] : []
      content {
      name  = azurerm_managed_disk.terramformpoc.*.name[2]
      lun = "1"
      managed_disk_id=azurerm_managed_disk.terramformpoc.*.id[2]
      disk_size_gb="32"
      create_option="attach"
}

    }
    */
}
 resource "azurerm_network_security_group" "data-plugin" {
  name                = "${var.vm_hostname}-nsg"
  location            = var.location
  resource_group_name = var.vmrg

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP1"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 }
 resource "azurerm_network_interface_security_group_association" "plugin-access" {
  network_interface_id=azurerm_network_interface.vm.id
  network_security_group_id=azurerm_network_security_group.data-plugin.id
}
