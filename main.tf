# data "template_file" "userdata_default" {
#   template = file("${path.module}/userdata.tpl")
#   vars = {
#     HOSTNAME = var.vm_hostname
#     default_user = var.default_user
#     json_users = jsonencode(var.users)
#   }

# }

locals {
  userdata_rendered = templatefile("${path.module}/userdata.tpl", {
    HOSTNAME     = var.vm_hostname
    default_user = var.default_user
    users        = var.users   # No need to jsonencode here!
  })
}

resource "esxi_guest" "vm" {
  guest_name         = var.vm_hostname
  disk_store         = var.disk_store

  memsize            = var.vm_memory
  numvcpus           = var.vm_cpus

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
    value = base64encode(local.userdata_rendered)
    # value = base64encode(data.template_file.userdata_default.rendered)
  }

  # Optional: fallback if guestinfo is preferred
  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata" = base64encode(local.userdata_rendered)
    # "userdata"          = base64gzip(data.template_file.userdata_default.rendered)
  }

  ovf_properties_timer = 90  # give VM time to boot & process OVF props

}
