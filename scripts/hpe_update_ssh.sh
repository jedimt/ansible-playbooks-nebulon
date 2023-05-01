#!/bin/bash
ansible-playbook -i inventory/hpe.yml playbooks/ansible-playbook-utility/update_ssh_known_hosts.yml
