Ansible Playbooks for Nebulon
=============================

** NOTICE: This repo is still a work in progress and not fully actualized **

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

The playbooks in this repo expect to have access to the following files that you will be required to replace with your own. You will need to re-create these files before you can successfully use the playbooks:

- credentials.yml -> Ansible vault protected passwords and SSH keys
- serials.yml -> Ansible vault protected hardware serial numbers for SPUs and hosts
- .vault_pass -> File containing the Ansible Vault password

Requirements
------------

These playbooks were developed and tested with the following versions:

- Ansible Core 2.14.1 (Ansible Community 7.4)
- Python 3.11.3
- Ubuntu 20/22 LTS

Minimal effort has been taken to test on prior Ansible and Python versions back to Ansible 2.12 and Python 3.8.

Playbook Dependancies
---------------------

Each playbook has it's own README.md laying out usage and dependancy information.

Ansible Controller
------------------

The following items must be configured on the Ansible controller:

    Apt packages:
    - sshpass
    - unzip

    Python modules:
    - nebpyclient
    - pyvmomi
    - jmespath

Ansible Galaxy
--------------

Roles required by these playbooks are hosted on Ansible Galaxy. The `requirements.yml` file lists all roles currently in service.

License
-------

MIT

Author Information
------------------

Aaron Patten
aaronpatten@gmail.com

