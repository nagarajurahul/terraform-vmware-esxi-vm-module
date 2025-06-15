# 🚀 ESXi VM Provisioning with Terraform + OVA + Cloud-Init

This project demonstrates how to **automatically provision virtual machines on an ESXi hypervisor** using:

- ✅ **Terraform** (with [`josenk/terraform-provider-esxi` provider])
- ✅ **OVA/OVF cloud images** (Ubuntu Cloud-Ready)
- ✅ **Cloud-Init** for user setup, SSH access, and automation

Designed for **DevOps Engineers**, **Cloud Engineers**, or **Infrastructure Automation** professionals building reproducible, infrastructure-as-code environments on home labs, edge servers, or data centers.

---

## 📦 What’s Included

- Automated VM creation from OVA
- Custom hostname, SSH keys, and optional passwords via OVF properties
- `cloud-init` for:
  - Adding users
  - Installing packages
  - Setting hostname and MOTD
  - Injecting SSH keys
- ESXi authentication via Terraform provider

---

## ☁️ Requirements

- **Terraform >= 0.12**
- **ESXi (Free or Paid)**
- **OVA file** (example: Ubuntu 24.04 cloud image)
- **ovftool** installed (optional, for inspecting .ova)

---

## 🔧 Setup Instructions

### 1️⃣ Clone This Repo

```bash
git clone https://github.com/nagarajurahul/terraform-vmware-esxi
cd terraform-vmware-esxi
```

### 2️⃣ Download a Cloud-Ready OVA
Get Ubuntu cloud images:

```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.ova
```


### 3️⃣ Customize terraform.tfvars

```bash
esxi_hostname   = "<your-esxi-hostname>"
esxi_hostport   = "22"
esxi_hostssl    = "443"
esxi_username   = "root"
esxi_password   = "<your-esxi-password>"

disk_store      = "datastore1"
virtual_network = "VM Network"
ovf_file        = "<your-ova-file>.ova"
vm_hostname     = "<rahul-linux-1>"
vm_password     = "<your-vm-password>"
ssh_public_key  = "ssh-ed25519 AAAAC3...your-key...user@host"
```

### 4️⃣ Configure Cloud-Init (userdata.tpl)

Change the username

### 5️⃣ Run Terraform

```bash
terraform init
terraform plan --var-file="custom.tfvars"
terraform apply --var-file="custom.tfvars"
```


## 🧠 Notes & Tips

✅ Use ovftool to inspect OVA: ovftool --hideEula <your-ova-file>.ova

❗ If password OVF property doesn't work, ensure:

- User exists in cloud-init
- lock_passwd: false is set
- plain_text_passwd: ... is used

🧑‍💻 Best practice: Use SSH keys instead of plain passwords.


---

## 📚 References

Terraform Provider: <https://github.com/josenk/terraform-provider-esxi>

Ubuntu Cloud Images: <https://cloud-images.ubuntu.com>

Cloud-Init Docs: <https://cloudinit.readthedocs.io>

## ✨ Author

Rahul Nagaraju
Cloud & DevOps Engineer
