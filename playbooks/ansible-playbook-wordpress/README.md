Playbook: Deploy Wordpress Demo
===============================

This playbook creates a simple Wordpress Kubernetes deployment with a MySQL database which is protected by persistent volumes.

Prerequisites
-------------

This playbook makes the following assumptions:
- There is a Kubernetes cluster (physical or virtual) available
- The kubeconfig file is available on a master/control node or is provided to the Ansible controller
- The prerequisite roles from the `requirements.yml` file have been installed

Roles Used
----------

    - jedimt.wordpress
    - kubernetes.core

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-wordpress/deploy-wordpress.yml

