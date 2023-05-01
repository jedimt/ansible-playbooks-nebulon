#!/bin/bash
# Author: Aaron Patten
# Copyright (c) 2023 Nebulon, Inc

#Clean up any files from previous run
rm ~/get-pip.py*
rm ~/nebulon-nebulon_on-*

#Set some colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
NORMAL=$(tput sgr0)

#Determine if this is the "control" host
IP=`ip addr | awk -F ' *|/' '$2 == "inet" {if ($3 != "127.0.0.1") {print $3; exit}}'`
HOSTNAME=`nslookup $IP | grep name | cut -d ' ' -f 3 | cut -d '.' -f 1`

printf '%s\n' "${BLUE}This is hostname: ${GREEN}$HOSTNAME"

if [ "$HOSTNAME" = server-09 ]; then

    printf '%s\n' "${GREEN}This is the K8s master node, beginning auto_k8s workflow!${NORMAL}"

    #Install Python packages
    printf '%s\n' "Downloading get-pip.py"
    wget -q https://bootstrap.pypa.io/get-pip.py -P ~/

    printf '%s\n' "Installing pip"
    python ~/get-pip.py

    printf '%s\n' "Installing NebPyClient"
    python -m pip install nebpyclient==2.0.8

    printf '%s\n' "Installing Ansible"
    python -m pip install ansible

    #Import the public SSH key for bitbucket.org
    ssh-keyscan github.com >> ~/.ssh/known_hosts

    #Clone the auto_k8s repository
    printf '%s\n' "Cloning the ansible-playbooks-nebulon repository"
    git clone git@github.com:jedimt/ansible-playbooks-nebulon.git ~/ansible-playbooks-nebulon

    #Install the Nebulon Ansible module
    printf '%s\n' "Installing Ansible module"
    ansible-galaxy collection install nebulon.nebulon_on

    #Run the Ansible playbook
    printf '%s\n' "${BLUE}Exceuting Ansible playbook!${NORMAL}"
    cd ~/ansible-playbooks-nebulon
    ansible-playbook -i inventory/lenovo.yml playbooks/ansible-playbook-azure-arc/onboard_k8s.yml

else
    printf '%s/n' "This is a K8s worker node, waiting for master."
fi