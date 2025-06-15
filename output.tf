output "vm_ip" {
  value = esxi_guest.vm.ip_address
  description = "IP address assigned to the VM"
}

output "vm_hostname" {
  value = var.vm_hostname
  description = "Hostname assigned to the VM"
}