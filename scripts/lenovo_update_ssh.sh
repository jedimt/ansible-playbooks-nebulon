#!/bin/bash
ansible-playbook -i inventory/lenovo.yml playbooks/ssh/update_known_hosts.yml
