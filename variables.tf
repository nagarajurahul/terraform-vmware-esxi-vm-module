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

variable "vm_memory" {
  default = 2048
}

variable "vm_cpus" {
  default = 2
}

variable "ovf_file" {
  
}

variable "default_user" {
  sensitive = true
}

variable "users" {
  type = map(object({
    password = string
    ssh_keys   = list(string)
  }))
}