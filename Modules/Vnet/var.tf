variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  }

variable "resourcegroup" {
  description = "Name of the resource group to be imported."
  type        = string
}

variable "location" {
  type= string
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  }

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  }

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  }
