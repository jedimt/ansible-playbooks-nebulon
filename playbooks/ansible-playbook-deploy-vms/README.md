Playbook: Deploy VMs
====================

This playbook deploys a one or more VMs (based on inventory) for application or platform uses (Kubernetes).

Prerequisites
-------------

This playbook makes the following assumptions:
- There is a template that can be used in the vCenter
- You have credentials to vCenter
- Network information for the VM (DNS, IP, etc) is set up
- The root user is available on the template
- The roles in the `requirements.yml` file have been installed on the Ansible controller.

Roles Used
----------

    - jedimt.deploy_vms

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-deploy-vms/deploy_vms.yml

Inventory
---------

This is the inventory file used in my environment:

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