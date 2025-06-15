variable "esxi_hostname" {
  default = "esxi"
}

variable "esxi_hostport" {
  default = "22"
}

variable "esxi_hostssl" {
  default = "443"
}

variable "esxi_username" {
  sensitive   = true
}

variable "esxi_password" {
  sensitive   = true
}

variable "virtual_network" {
  
}

variable "disk_store" {
  
}

# variable "guest_name" {
  
# }

# variable "guestos" {
  
# }

variable "vm_hostname" {
  
}

variable "vm_password" {
  sensitive   = true
}

variable "ovf_file" {
  
}

variable "ssh_public_key" {
  sensitive   = true
}