#cloud-config
# %{ set users = jsondecode(json_users) }

users:
%{ for username, user in users ~}
  - name: ${username}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    ssh-authorized-keys:
%{ for key in user.ssh_keys ~}
      - ${key}
%{ endfor ~}
    lock_passwd: false
%{ endfor ~}

# Allow password login (required for OVF 'password' to work)
ssh_pwauth: true

chpasswd:
  list: |
%{ for username, user in users ~}
    ${username}:${user.password}
%{ endfor ~}
  expire: False

system_info:
  default_user:
    name: ${default_user}
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash

packages:
  - curl
  - git

runcmd:
  - hostnamectl set-hostname ${HOSTNAME}
  - ip a >> /var/log/cloud-init-network.log
  - echo "Welcome to ${HOSTNAME}" > /etc/motd
  - echo "Cloud Init completed successfully." >> /var/log/cloud-init-done.log
