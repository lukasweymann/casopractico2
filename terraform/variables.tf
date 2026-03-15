variable "location" {
  default = "spaincentral"
}

variable "resource_group_name" {
  default = "rg-casopractico2"
}

variable "acr_name" {
  default = "acrcasopractico2pm8471"
}

variable "vm_name" {
  default = "vm-casopractico2"
}

variable "vm_location" {
  default = "swedencentral"
}

variable "vm_size" {
  default = "Standard_B2s_v2"
}

variable "admin_username" {
  default = "azureuser"
}

variable "aks_name" {
  default = "aks-casopractico2"
}

variable "aks_location" {
  default = "swedencentral"
}

variable "aks_node_count" {
  default = 1
}

variable "aks_vm_size" {
  default = "Standard_B2s_v2"
}