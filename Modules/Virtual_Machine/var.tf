variable "location" {}
variable "vm_hostname"{
    }
variable "vnet_subnet_id" {}
variable "vmrg" {}
variable "app_instances_count"{
    default="1"
}
variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
  }
variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = "latest"
}
variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete datadisk when machine is terminated."
  default     = false
}
variable "admin_username" {
  default="dpuser"
  }
variable "admin_password" {
  default="dpuser@123"
}
variable "vnet"{
  type        = list(string)
}
variable "snapshot" {
  type        = list(string)
}
variable "additional_data_disk" {

description = "Specify if an additional Data Disks should be created for each VM"

default = false

}
