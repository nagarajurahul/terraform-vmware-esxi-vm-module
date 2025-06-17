data "template_file" "userdata_default" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    HOSTNAME = var.vm_hostname
    HELLO    = "Hello ESXi World!"
    SSH_PUBLIC_KEY = var.ssh_public_key
    PASSWORD = var.vm_password
  }
}

resource "esxi_guest" "vm" {
  guest_name         = var.vm_hostname
  disk_store         = var.disk_store

  network_interfaces {
    virtual_network = var.virtual_network
  }

  ovf_source        = var.ovf_file

  ovf_properties {
    key = "hostname"
    value = var.vm_hostname
  }

  # Not working
  ovf_properties {
    key = "password"
    value = var.vm_password
  }

  ovf_properties {
    key   = "instance-id"
    value = "vm-${var.vm_hostname}"
  }

  ovf_properties {
    key = "user-data"
    value = base64encode(data.template_file.userdata_default.rendered)
  }

  # Optional: fallback if guestinfo is preferred
  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.userdata_default.rendered)
  }

  ovf_properties_timer = 90  # give VM time to boot & process OVF props

}
