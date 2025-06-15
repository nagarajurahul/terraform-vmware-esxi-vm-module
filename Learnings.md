📚 Full Learning Journey – Terraform + ESXi Cloud-Init VM Automation
This section documents everything I learned while building an enterprise-grade automation solution using Terraform, cloud-init, and the free version of ESXi. The goal was to automate VM provisioning in a way that mirrors cloud-like workflows, without relying on vCenter or external orchestration platforms.

---

## 1️⃣ Understanding the Landscape

- ✅ Realized ISO images are not automation-friendly — they require manual installation and CD removal, making them unfit for headless or repeatable provisioning.

- ✅ Learned that OVA (Open Virtual Appliance) files are cloud-ready, especially those bundled with cloud-init support. They contain pre-configured virtual machines and are ideal for automated Terraform workflows.

- ✅ Understood the difference between:

    - OVA – A single file archive containing the OVF descriptor and disk images.

    - OVF – A folder of separate files, including the VM descriptor and disks.

---

## 2️⃣ ESXi Platform Internals

- 🔒 Found out that ESXi disables password-based SSH login by default. To enable it:

    - Edit `/etc/ssh/sshd_config` → PasswordAuthentication yes

    - Make it persistent with `/etc/rc.local.d/local.sh`

- 🧠 Learned how ESXi handles hostnames and IPs:

    - Use `getent hosts` to resolve hostnames

    - Use `/etc/hosts` for static hostname mappings in your system

---

## 3️⃣ Terraform + josenk/esxi Provider

- 🛠 Chose the `josenk/terraform-provider-esxi` provider — the only viable option for automating free ESXi hosts.

- 🧪 Faced and resolved issues with Terraform plugin installation (must install locally, not fetched automatically from GitHub).

- 🧱 Built Terraform configuration with proper main.tf, variables.tf, and outputs.tf, managing:

    - Host connection
    - OVF file selection
    - Virtual networking
    - VM disk store
    - SSH credentials and metadata

---

## 4️⃣ Cloud-Init Integration

- 📦 Created a modular `userdata.tpl` file to automate:
    - Hostname setup
    - User creation (ubuntu, rahul)
    - SSH key injection
    - Sudo access and package installation
    - Custom boot-time messages and log output

- 📜 Verified `cloud-init` logs using:
    - sudo cat /var/log/cloud-init.log | grep password
    - sudo cat /var/lib/cloud/instance/user-data.txt
    - cloud-init query ds

- 🔍 Learned how `chpasswd` can unlock accounts, and how `lock_passwd` behaves:
    - `lock_passwd: false` → enables password login
    - `ssh_pwauth: true` required in cloud-init
    - `plain_text_passwd`: used for user login provisioning

---

## 5️⃣ OVF Tool & OVA Insights

- 🔍 Installed the OVF Tool to inspect and validate OVA files:

    - Used `ovftool --hideEula file.ova` to read OVA metadata

- ⚠️ Discovered macOS M1 is not supported for OVF Tool — used Windows/Linux instead

- 📥 Explored official OVA sources:

    - Ubuntu Cloud Images

    - Considered using `Packer` to build custom OVAs for future use

---

## 6️⃣ Secure Automation Practices

- ✅ Marked sensitive Terraform inputs (vm_password, ssh_public_key) with sensitive = true

- 🔐 Planned to eventually secure secrets using tools like Vault or SOPS

- 🛡 Implemented both `ovf_properties` and `guestinfo` blocks for redundancy in cloud-init delivery

---

## 7️⃣ Practical Configuration & Networking

- 💡 Learned about VM boot disk types:

    - Thin provisioning vs. Thick (zeroed/lazy) provisioning

- 🧬 Enabled nested virtualization inside ESXi VM to support Docker or Kubernetes VMs

- 🔄 Used scp to copy files from macOS host into VMs

---

## 8️⃣ Next-Level Enhancements in Progress

- ✅ Captured VM metadata like IP address and hostname as Terraform outputs

- 🎯 Aiming for modular multi-VM deployments using count or for_each

- 📘 Documenting all components and behaviors in a professional README