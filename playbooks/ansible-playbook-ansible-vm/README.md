Playbook: Ansible VM
====================

This playbook deploys a Ubuntu VM to be used for testing Ansible playbooks in a "clean" environment.

Prerequisites
-------------

This playbook makes the following assumptions:
- There is a template that can be used in the vCenter
- You have credentials to vCenter
- Network information for the VM (DNS, IP, etc) is set up
- The root user is available on the template
- The OVFTool tar file is available from http source on your network
- The roles in the `requirements.yml` file have been installed on the Ansible controller.

Roles Used
----------

    - jedimt.deploy_vms
    - jedimt.customize_vms
    - jedimt.ssh
    - jedimt.authorized_keys
    - geerlingguy.ansible

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/ansible-vm.yml playbooks/ansible-playbook-ansible-vm/deploy_ansible_vm.yml