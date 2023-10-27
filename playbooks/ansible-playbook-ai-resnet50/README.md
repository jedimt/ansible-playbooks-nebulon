Playbook: Install ResNet-50 Benchmark
==========================================

This playbook does a complete bare metal build using Ubuntu 22.04 to install the ResNet v1.5 Tensorflow benchmark from NVIDIA.

Prerequisites
-------------

This playbook makes the following assumptions:
- You have a template set up to boot from Nebulon with an Ubuntu 22.04 image
- You have defined the volumes you want in the vars/ directory in the form of `nPod_{{demopod}}.yml`.
- Python 3.10 is installed in the Ubuntu 22.04 deployed image. This is the default for 22.04 LTS.

Roles Used
----------

    - jedimt.nebulon_create_npod
    - jedimt.authorized_keys
    - jedimt.ssh
    - jedimt.apt
    - jedimt.network_setup
    - jedimt.nebulon_manage_volumes
    - jedimt.linux_add_scsi_dev
    - jedimt.resnet50

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-ai-resnet50/main.yml

