Playbook:Kubernetes VM Deployment
=================================

Deploys a highly available Kubneretes cluster on a vSphere cluster, installs the VMware CSI and deploys the kube-prometheus project. This playbook requires a vCenter set up by the `vmware_fullstack_playbook_vsphere8.yml` playbook in this repository.

**_NOTE_**: This set of playbooks relies on an unsupported method of customizing a templated image of ESXi and is for demonstration purposes only.


Prerequisites
-------------

This playbook is for demonstration purposes only.

Roles Used
----------

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

If a vSphere cluster has not been created, execute the `vmware_fullstack_playbook_vsphere8.yml` playbook to build the physical environment:

    ansible-playbook -i inventory/lenovo.yml playbooks/ansible-playbook-vmware-fullstack/vmware_fullstack_playbook_vsphere8.yml

When the physical deployment is completed, the virtual Kubernetes deployment can be started:

    ansible-playbook -i inventory/lenovo-brb.yml playbooks/ansible-playbook-k8s-virtual/deploy_k8s_vms.yml

Inventory
---------

This is the inventory I use for the virtual Kubernetes deployment:

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