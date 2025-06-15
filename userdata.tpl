#cloud-config

users:
  - name: ubuntu
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash

packages:
  - curl
  - git

runcmd:
  - echo "Welcome to ${HOSTNAME}" > /etc/motd
