Ansible Playbooks for Nebulon
=============================

** This repo is still a work in progress and not fully actualized **

This repo contains a set of curated Ansible playbooks focused on deploying solution sets for the TME and SE labs at Nebulon. These playbooks are focused on full stack deployments of the following solutions:

- VMware (bare-metal)
- Kubernetes (bare-metal)
- Kubernetes (virtual)
- Linux (bare-metal)
- MongoDB (bare-metal)
- Kadalu (virtual)

There are additional playbooks focused on automating functions:

- Nebulon volume management
- Creation of vCenter OVF files
- Wordpress demo app

Setup
-----

The playbooks in this repo expect to have access to the following files that are not part of this repo. You will need to create these files before you can successfully use the playbooks:

- credentials.yml -> Ansible vault protected passwords and SSH keys
- serials.yml -> Ansible vault protected serial numbers for Nebulon SPUs and servers
- .vault_pass -> File containing the Ansible Vault password

Requirements
------------

These playbooks were developed and tested with the following versions:

- Ansible Core 2.14.1 (Ansible Community 7.2.0)
- Python 3.10.6
- Ubuntu 20/22 LTS

Minimal effort has been taken to test on prior Ansible and Python versions back to Ansible 2.12 and Python 3.8.

Playbook Dependancies
---------------------

Each playbook has it's own README.md laying out usage and dependancy information.

Ansible Galaxy
--------------

Hosting the playbook required roles in Galaxy is future endevor. These playbooks rely on a set of Ansible roles available in this repo. Currently these roles must be manually cloned to the Ansible controller. In the future these roles will be uploaded to Ansible Galaxy.

