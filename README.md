# 🚀 ESXi VM Provisioning with Terraform + OVA + Cloud-Init

This project provides a **reusable Terraform module** to **automatically provision virtual machines on an ESXi hypervisor** using:

- ✅ **Terraform** (with [`josenk/terraform-provider-esxi` provider])
- ✅ **OVA/OVF cloud images** (Ubuntu Cloud-Ready)
- ✅ **Cloud-Init** for user setup, SSH access, and automation

Designed for **DevOps Engineers**, **Cloud Engineers**, or **Infrastructure Automation** professionals building reproducible, infrastructure-as-code environments on home labs, edge servers, or data centers.

---

## 📦 What’s Inside This Module

- Terraform-managed ESXi VM lifecycle

- Accepts:

  - Custom vm_hostname, vm_password, vm_memory, vm_cpus and ssh_public_key

  - Disk and virtual network configuration

  - Path to .ova cloud image

- Uses template_file to inject dynamic cloud-init content

- Sends cloud-init via both:

  - ovf_properties["user-data"]

  - guestinfo.userdata (gzip+base64 fallback)

- Does not include provider block — expected to be defined in the parent Terraform configuration

---

## ☁️ Requirements

- **Terraform >= 0.12**
- **ESXi host (Free or Licensed)**
- **josenk/esxi provider**
- **Cloud-ready OVA file** (example: Ubuntu 24.04 cloud image)
- **ovftool** installed

---

## 🔧 Setup Guide


### 1️⃣ Download a Cloud-Ready OVA
Get Ubuntu cloud images:

```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.ova
```

### 2️⃣ Define the provider (in parent project)

```bash
provider "esxi" {
  esxi_hostname   = "<your-esxi-hostname>"
  esxi_hostport   = "22"
  esxi_hostssl    = "443"
  esxi_username   = "<your-esxi-username>"
  esxi_password   = "<your-esxi-password>"
}
```

### 3️⃣ Add module in your parent project

```bash

module "vm" {
  source = "git::https://github.com/nagarajurahul/terraform-vmware-esxi-vm-module.git"

  esxi_hostname   = "<your-esxi-hostname>"
  esxi_username   = "<your-esxi-username>"
  esxi_password   = "<your-esxi-password>"
 
  virtual_network = "VM Network"
  disk_store      = "datastore1"
  vm_hostname     = "rahul-linux-1"
  vm_password     = "<your-vm-password>"
  vm_memory       = 2048
  vm_cpus         = 2
  ovf_file        = "noble-server-cloudimg-amd64.ova"
  ssh_public_key  = "ssh-ed25519 AAAAC3...your-key...user@host"
}
```


### 4️⃣ Run Terraform for your parent project

```bash
terraform init

terraform plan
or
terraform plan --var-file="custom.tfvars"

terraform apply
or
terraform apply --var-file="custom.tfvars"
```

---

## 📜 Output

- VM Hostname

- VM IP address (once booted via DHCP)

---

## 🧠 Notes & Tips

✅ Use ovftool to inspect OVA: ovftool --hideEula <your-ova-file>.ova

❗ If password OVF property doesn't work, ensure:

- User exists in cloud-init
  - `chpasswd` must be configured
  - or
  - `lock_passwd: false` is set and `plain_text_passwd: <your-user-password>` is configured

🧑‍💻 Best practice: Use SSH keys instead of plain passwords.


---

## 🔧 Future Improvements

- 🔁 Support multi-VM creation via for_each

- 📦 Add ISO support, resource pools, and tagging

- 🔐 Vault/SOPS integration for secure secrets

- 🧪 Add unit tests and CI for validation

- 🧱 Enhance cloud-init templates for flexibility

- 🛰 Enable IP configuration and DNS registration

- 🔄 Post-provisioning automation using Ansible or remote-exec


---

## 📚 References

- Terraform Provider: <https://github.com/josenk/terraform-provider-esxi>

- Ubuntu Cloud Images: <https://cloud-images.ubuntu.com>

- Cloud-Init Docs: <https://cloudinit.readthedocs.io>

## ✨ Author

**Rahul Nagaraju**
- Cloud & DevOps Engineer

## 📄 License
This project is licensed under the MIT License

```
MIT License

Copyright (c) 2025 Rahul Nagaraju

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
