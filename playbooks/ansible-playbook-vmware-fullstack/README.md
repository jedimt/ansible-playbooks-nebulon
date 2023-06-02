Playbook: VMware Full Stack Deployment
======================================

There are three playbooks in this folder:

- `vmware_fullstack_playbook_vsphere8.yml` -> Creates a nPod using existing ESXi image, deploys a VCSA (version 8.x) to the nPod, adds the ESXi hosts to the self-hosted VCSA and clones a template to the vSphere cluster.
- `vmware_fullstack_playbook_vsphere7.yml` -> Creates a nPod using existing ESXi image, deploys a VCSA (version 7.x) to the nPod, adds the ESXi hosts to the self-hosted VCSA and clones a template to the vSphere cluster.

**_NOTE_**: The preceeding playbooks rely on an unsupported method of customizing a templated image of ESXi and is for demonstration purposes only.

- `vmware_fullstack_playbook_vsphere8_iso.yml` -> Uses a customized ESXi ISO image to automate the installation of ESXi. This is a supported method for deploying ESXi, however it requires creating a custom ISO and managing the virtual media state on the server out of band management controller (iLOM, iDRAC, XCC, etc) which makes it slower and more error prone. Instructions for creating a customized ISO image can be found in the [Appendix A](https://on.nebulon.com/docs/en-us/solutions/vmware-vsphere/11a2ae83f5ce16d8975f3917eff34a39) section of the VMware vSphere solutions guide at on.nebulon.com/docs.

Prerequisites
-------------

This playbook is for demonstration purposes only.

Roles Used
----------

    - jedimt.nebulon_create_npod
    - jedimt.vmware_customize_esxi
    - jedimt.ssh
    - jedimt.vmware_vcsa_embedded_install
    - jedimt.vmware_vcsa_customization
    - jedimt.clone_template

Example Execution
-----------------

To execute the playbook run the following command:

    ansible-playbook -i inventory/lenovo.yml playbooks/ansible-playbook-vmware-fullstack/vmware_fullstack_playbook_vsphere8.yml

Inventory
---------

This is the inventory file used in my environment for the physical hosts:

```yaml
# Variables to use specific to localhost (for working with APIs)
all:
  hosts:
    localhost:
      # Since there are multiple physical groups of systems I specify
      # a grouping of equipment to use for naming the nPod. This is unique
      # per inventory.
      demopod: "lenovo"
      # How to wait (in minutes) for hosts to boot after nPod creation
      wait_hosts: 3
      # How long to wait for scripted install of ESXi
      wait_hosts_esxi_install: 15
      # Netmask for data ports on Medusa cards (TME=24; Demopods=28)
      netmask_bits: 24
      # vCenter variables unique to the Lenovo systems
      vcenter_hostname: "devvcsa.tme.nebulon.com"

# Physical server inventory
servers:
  hosts:
    server-09.tme.nebulon.com:
      spu_serial: 012386435A39449519
      spu_address: 10.100.29.117
    server-10.tme.nebulon.com:
      spu_serial: 01231C5BA68435FC19
      spu_address: 10.100.29.118
    server-11.tme.nebulon.com:
      spu_serial: 01234C1DDA95332EEE
      spu_address: 10.100.29.119
    server-12.tme.nebulon.com:
      spu_serial: 01236AE13059FD35EE
      spu_address: 10.100.29.120
##### /VMware Bare Metal #####

##### K8s Inventory #####
# Physical inventory for bare metal K8s deployments
k8s:
  hosts:
    server-09.tme.nebulon.com:
    server-10.tme.nebulon.com:
    server-11.tme.nebulon.com:
    server-12.tme.nebulon.com:
  children:
    k8s_master:
      hosts:
        server-09.tme.nebulon.com:
    k8s_nodes:
      hosts:
        server-10.tme.nebulon.com:
        server-11.tme.nebulon.com:
        server-12.tme.nebulon.com:
##### /K8s Inventory #####

spus:
  hosts:
    medusa-b0421.tme.nebulon.com:
    medusa-b0428.tme.nebulon.com:
    medusa-a912.tme.nebulon.com:
    medusa-a915.tme.nebulon.com:
  vars:
    ansible_python_interpreter: auto_silent

# VMware Bare metal
vmware:
  hosts:
    server-09.tme.nebulon.com:
    server-10.tme.nebulon.com:
    server-11.tme.nebulon.com:
    server-12.tme.nebulon.com:
  vars:
    vcsa_name: "devvcsa.tme.nebulon.com"
    vcsa_size: "small"
    vcenter_ip: 10.100.24.31
    vcsa_gw: 10.100.24.1
    vcsa_cidr: 22
    vcsa_dns: 10.100.72.10
    vcsa_ntp: 10.100.72.10
    vcsa_sso_domain: "vsphere.local"
    vcsa_sso_password: "{{ vault_vcsa_sso_password }}"
    vcsa_password: "{{ vault_vcsa_sso_password }}"
    vcsa_network: "VM Network"
# VCSA
vcsa:
  hosts:
    devvcsa.tme.nebulon.com:

redfish:
  hosts:
    server-09-lom.tme.nebulon.com:
      baseuri: server-09-lom.tme.nebulon.com
    server-10-lom.tme.nebulon.com:
      baseuri: server-10-lom.tme.nebulon.com
    server-11-lom.tme.nebulon.com:
      baseuri: server-11-lom.tme.nebulon.com
    server-12-lom.tme.nebulon.com:
      baseuri: server-12-lom.tme.nebulon.com

myhosts:
  children:
    redfish:
  vars:
    username: Administrator
    password: "{{ vault_ilom_password }}"
    # Local directory where all results are placed
    rootdir: ../../../results

    # Shorter name for inventory_hostname
    # Refers to the logical inventory hostname (example: redfish1)
    host: "{{ inventory_hostname }}"
```
