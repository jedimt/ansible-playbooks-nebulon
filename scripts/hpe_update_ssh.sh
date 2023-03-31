#!/bin/bash
ansible-playbook -i inventory/hpe.yml playbooks/ssh/update_known_hosts.yml
