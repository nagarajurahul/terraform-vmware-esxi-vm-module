terraform {
  required_version = ">= 0.12"
}

provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

data "template_file" "userdata_default" {
  template = file("userdata.tpl")
  vars = {
    HOSTNAME = var.hostname
    HELLO    = "Hello ESXi World!"
    SSH_PUBLIC_KEY = var.ssh_public_key
  }
}

resource "esxi_guest" "vmtest" {
  guest_name         = var.hostname
  disk_store         = var.disk_store

  network_interfaces {
     virtual_network = var.virtual_network
  }

  ovf_source        = var.ovf_file

  ovf_properties {
    key = "hostname"
    value = var.hostname
  }

  ovf_properties {
    key = "password"
    value = var.password
  }

  ovf_properties {
    key   = "instance-id"
    value = "vm-${var.hostname}"
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