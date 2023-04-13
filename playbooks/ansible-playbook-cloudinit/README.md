Playbook: Cloud-init Setup
====================

This playbook puts down the basic configuration required for cloud-init to run on a Ubuntu VM utilizing the "nocloud" provider.

Prerequisites
-------------

This playbook makes the following assumptions:
- A Linux host is available with a recent version of cloud-init installed
- You have modified the jedimt.cloud_init role to fit your environment
- The roles in the `requirements.yml` file have been installed on the Ansible controller.

Roles Used
----------

    - jedimt.cloud_init

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-cloudinit/cloudinit-setup.yml