Playbook: VMware Full Stack Deployment
======================================

There are three playbooks in this folder:

- `vmware_fullstack_playbook_vsphere8.yml` -> Creates a nPod using existing ESXi image, deploys a VCSA (version 8.x) to the nPod, adds the ESXi hosts to the self-hosted VCSA and clones a template to the vSphere cluster.
- `vmware_fullstack_playbook_vsphere7.yml` -> Creates a nPod using existing ESXi image, deploys a VCSA (version 7.x) to the nPod, adds the ESXi hosts to the self-hosted VCSA and clones a template to the vSphere cluster.
- `vmware_fullstack_playbook_phase2.yml` -> Deploys a highly available Kubneretes cluster on the vSphere cluster, installs the VMware CSI and deploys the kube-prometheus project. This playbook requires a different inventory (switching from physical to virtual resources) so must be executed separately after the phase 1 playbook runs.

**_NOTE_**: This set of playbooks relies on an unsupported method of customizing a templated image of ESXi and is for demonstration purposes only.


Prerequisites
-------------

This playbook is for demonstration purposes only.

Roles Used
----------

    # These are the roles for phase 1
    - jedimt.nebulon_create_npod
    - jedimt.vmware_customize_esxi
    - jedimt.ssh
    - jedimt.vmware_vcsa_embedded_install
    - jedimt.vmware_vcsa_customization
    - jedimt.clone_template
    # roles used in phase 2
    - jedimt.deploy_vms
    - jedimt.customize_vms
    - jedimt.authorized_keys
    - jedimt.ssh
    - jedimt.apt
    - jedimt.haproxy
    - jedimt.kubernetes_prep
    - jedimt.kubernetes_create_cluster
    - jedimt.kubernetes_cni
    - jedimt.kubernetes_join_nodes
    - jedimt.kubernetes_metallb
    - jedimt.vmware_csi
    - jedimt.helm
    - jedimt.kubernetes_nginx_ingress
    - jedimt.golang
    - jedimt.kubernetes_kube_prometheus

Example Execution
-----------------

To execute the phase 1 playbook (physical deployment), run the following command:

    ansible-playbook -i inventory/lenovo.yml playbooks/ansible-playbook-vmware-fullstack/vmware_fullstack_playbook_vsphere8.yml

When phase 1 is completed, the phase 2 playbook (virtual deployment) can be executed to deploy Kubernetes:

    ansible-playbook -i inventory/lenovo-brb.yml playbooks/ansible-playbook-vmware-fullstack/vmware_fullstack_playbook_phase2.yml

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

This is the inventory I use for the virtual deployment (phase 2):

```yaml
# Server inventory (VMs) - used to deploy the VMs
all:
  hosts:
    localhost:

servers:
  hosts:
    dev-k8s-haproxy-01.tme.nebulon.com:
    dev-k8s-master-01.tme.nebulon.com:
    dev-k8s-master-02.tme.nebulon.com:
    dev-k8s-master-03.tme.nebulon.com:
    dev-k8s-node-01.tme.nebulon.com:
    dev-k8s-node-02.tme.nebulon.com:
    dev-k8s-node-03.tme.nebulon.com:
    dev-k8s-node-04.tme.nebulon.com:

# HA Proxy machine to support multi-master K8s deployments
haproxy:
  hosts:
    dev-k8s-haproxy-01.tme.nebulon.com:
      guest_custom_ip: '10.100.24.40'
      guest_notes: "K8s HAProxy for multi-master"
      size_gb: 40
      memory_mb: 4096
      guest_vcpu: 2

# The primary (first) K8s control plane node. Only master/control node in
# single master deployments
k8s_master:
  hosts:
    dev-k8s-master-01.tme.nebulon.com:
      guest_custom_ip: '10.100.24.41'
      guest_notes: "Dev K8s control node"
      size_gb: 40
      memory_mb: 8192
      guest_vcpu: 2
      loadbalancer: "dev-k8s-haproxy-01.tme.nebulon.com:6443"

# The additional control plane K8s nodes
k8s_control:
  hosts:
    dev-k8s-master-02.tme.nebulon.com:
      guest_custom_ip: '10.100.24.42'
      guest_notes: "Dev K8s control node"
      size_gb: 40
      memory_mb: 8192
      guest_vcpu: 2
    dev-k8s-master-03.tme.nebulon.com:
      guest_custom_ip: '10.100.24.43'
      guest_notes: "Dev K8s control node"
      size_gb: 40
      memory_mb: 8192
      guest_vcpu: 2

# K8s nodes
k8s_nodes:
  hosts:
    dev-k8s-node-01.tme.nebulon.com:
      guest_custom_ip: '10.100.24.44'
      guest_notes: "Dev K8s worker node"
      size_gb: 100
      memory_mb: 8192
      guest_vcpu: 4
    dev-k8s-node-02.tme.nebulon.com:
      guest_custom_ip: '10.100.24.45'
      guest_notes: "Dev K8s worker node"
      size_gb: 100
      memory_mb: 8192
      guest_vcpu: 4
    dev-k8s-node-03.tme.nebulon.com:
      guest_custom_ip: '10.100.24.46'
      guest_notes: "Dev K8s worker node"
      size_gb: 100
      memory_mb: 8192
      guest_vcpu: 4
    dev-k8s-node-04.tme.nebulon.com:
      guest_custom_ip: '10.100.24.47'
      guest_notes: "Dev K8s worker node"
      size_gb: 100
      memory_mb: 8192
      guest_vcpu: 4

# Inventory super-set for the K8s machines
k8s:
  hosts:
    dev-k8s-haproxy-01.tme.nebulon.com:
    dev-k8s-master-01.tme.nebulon.com:
    dev-k8s-master-02.tme.nebulon.com:
    dev-k8s-master-03.tme.nebulon.com:
    dev-k8s-node-01.tme.nebulon.com:
    dev-k8s-node-02.tme.nebulon.com:
    dev-k8s-node-03.tme.nebulon.com:
    dev-k8s-node-04.tme.nebulon.com:
  children:
    k8s_master:
      hosts:
         dev-k8s-master-01.tme.nebulon.com:
    k8s_control:
      hosts:
        dev-k8s-master-02.tme.nebulon.com:
        dev-k8s-master-03.tme.nebulon.com:
    k8s_nodes:
      hosts:
        dev-k8s-node-01.tme.nebulon.com:
        dev-k8s-node-02.tme.nebulon.com:
        dev-k8s-node-03.tme.nebulon.com:
        dev-k8s-node-04.tme.nebulon.com:

# Machine short names, used by vmware_csi.yml
k8s_short:
  hosts:
    dev-k8s-master-01:
    dev-k8s-master-02:
    dev-k8s-master-03:
    dev-k8s-node-01:
    dev-k8s-node-02:
    dev-k8s-node-03:
    dev-k8s-node-04:
```