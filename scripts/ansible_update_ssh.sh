#!/bin/bash
ansible localhost -i inventory/ansible-vm.yml -m include_role -a name=ansible-role-ssh-update-known-hosts