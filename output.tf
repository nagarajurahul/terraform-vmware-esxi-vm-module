output "vm_ip" {
  value = esxi_guest.vm.ip_address
  description = "IP address assigned to the VM"
}
