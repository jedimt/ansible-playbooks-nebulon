Playbook: Baremetal K3s Kubernetes
==================================

The playbook `k3s_baremetal_install.yml` deploys a K3s Kubernetes cluster from scratch along with the Nebulon CSI driver and the `kube-prometheus` project. It is an extensive and complicated playbook with may roles involved which may prove somewhat challenging when adapting this playbook.

Prerequisites
-------------

This playbook makes the following assumptions:
- You have a Linux boot image already available in Nebulon ON and that this image boots up to a "usable" state without user intervention. In this case, "usable" means the server is available on the network with its permanent IP already assigned and functional DNS.
- The roles in the `requirements.yml` file have been installed on the Ansible controller.

Roles Used
----------

    - jedimt.nebulon_create_npod
    - jedimt.authorized_keys
    - jedimt.ssh
    - jedimt.apt
    - jedimt.network_setup
    - xanmanning.k3s
    - jedimt.helm
    - jedimt.nebulon_csi
    - jedimt.golang
    - jedimt.kubernetes_kube_prometheus

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-k3s-baremetal/k3s_baremetal_install.yml

Inventory
---------

This is the inventory file used in my environment:

```yaml
# Variables to use specific to localhost (for working with APIs)
all:
  hosts:
    localhost:
      # Since there are multiple physical groups of systems I specify
      # a grouping of equipment to use for naming the nPod. This is unique
      # per inventory.
      demopod: "lenovo"
      # How long to wait (in minutes) for hosts to boot after nPod creation
      wait_hosts: 3

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

##### /K3s Inventory #####
k3s_cluster:
  hosts:
    server-09.tme.nebulon.com:
      k3s_control_node: true
    server-10.tme.nebulon.com:
      k3s_control_node: true
    server-11.tme.nebulon.com:
      k3s_control_node: true
    server-12.tme.nebulon.com:
      k3s_control_node: false
  children:
    k3s_master:
      hosts:
        server-09.tme.nebulon.com:
##### /K3s Inventory #####

# spus:
#   hosts:
#     medusa-b0421.tme.nebulon.com:
#     medusa-b0428.tme.nebulon.com:
#     medusa-a912.tme.nebulon.com:
#     medusa-a915.tme.nebulon.com:
#   vars:
#     ansible_python_interpreter: auto_silent

# Redfish, used for iLOM tasks, like rebooting hosts
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