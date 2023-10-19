Playbook: Install MLPerf Storage Benchmark
==========================================

This playbook does a complete bare metal build using Ubuntu 22.04 to install the MLCommons MLPerf Storage I/O benchmark.

Prerequisites
-------------

This playbook makes the following assumptions:
- You have a template set up to boot from Nebulon with an Ubuntu 22.04 image
- You have defined the volumes you want in the vars/ directory in the form of `nPod_{{demopod}}.yml`.
-

Roles Used
----------

    - jedimt.nebulon_create_npod
    - jedimt.authorized_keys
    - jedimt.ssh
    - jedimt.apt
    - jedimt.network_setup
    - jedimt.nebulon_manage_volumes
    - jedimt.linux_add_scsi_dev
    - jedimt.mlperf

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-ai-mlperf

