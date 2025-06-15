output "vm_ip" {
  value = esxi_guest.vmtest.ip_address
  description = "IP address assigned to the VM"
}
