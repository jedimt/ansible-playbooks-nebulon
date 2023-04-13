Playbook: Manage Nebulon Volumes
================================

This playbook can manage Nebulon volumes and their exports.

Prerequisites
-------------

This playbook makes the following assumptions:
- There is free capacity to create volumes
- The prerequisite roles from the `requirements.yml` file have been installed

Roles Used
----------

    - jedimt.nebulon_manage_volumes

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-nebulon-volume/manage_nebulon_volumes.yml

