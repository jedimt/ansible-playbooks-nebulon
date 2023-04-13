Playbook: Create vCenter OVF
==============================

This playbook creates a vCenter OVF file from the official VMware VCSA ISO image. This is used in the Nebulon TME labs to automate VCSA deployments in self-hosted scenarios where the VCSA is being deployed to unmanaged ESXi hosts.

Prerequisites
-------------

This playbook makes the following assumptions:
- There is a Linux VM or physical machine available to execute the workflow
- OVFTool is installed on the Linux machine
- The Linux machine has sufficient capacity for the operation

Roles Used
----------

    - jedimt.vcenter_ovf

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-vcenter-ovf/create_vcsa_ovf.yml

Inventory
---------

This is the inventory file used in my environment:

```yaml
# Inventory file for the linuxdev VM
all:
  hosts:
    linuxdev.tme.nebulon.com:
```