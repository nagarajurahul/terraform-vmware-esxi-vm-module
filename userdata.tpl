#cloud-config

users:
  - name: ubuntu
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    ssh-authorized-keys:
      - ${SSH_PUBLIC_KEY}

# Allow password login (required for OVF 'password' to work)
ssh_pwauth: true

packages:
  - curl
  - git

runcmd:
  - date >/root/cloudinit.log
  - hostnamectl set-hostname ${HOSTNAME}
  - echo ${HELLO} >>/root/cloudinit.log
  - echo "Done cloud-init" >>/root/cloudinit.log
  - ip a >/dev/tty1
  - echo "Welcome to ${HOSTNAME}" > /etc/motd
  - echo "Initialization complete." >> /var/log/cloud-init-done.log
