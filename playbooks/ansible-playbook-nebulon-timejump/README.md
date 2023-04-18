Playbook: Nebulon TimeJump Demo
===============================

This playbook is used to demo the benefits of the Nebulon TimeJump feature. This playbook executes a set of steps to simulate a catastrophic situation in a VMware vSphere environment hosted on a Nebulon nPod and then recover the environment. The playbook does the following actions:

- Deletes the virtual Kubneretes cluster running on the vSphere cluster
- Corrupts the boot volume for the ESXi hosts
- Causes the ESXi hosts to crash (PSOD)

This effectively wipes out the entire virtual environment. From this point, TimeJump can be used to recover the environment to the last Nebulon snapshot set taken before the simulated attack took place as part of a demo. The TimeJump recovery is run manually after this playbook has been executed.

Prerequisites
-------------

This playbook assumes a Nebulon nPod has been built using the [ansible-playbook-vmware-fullstack](../ansible-playbook-vmware-fullstack/vmware_fullstack_playbook_vsphere8.yml) playbook which will create all the prerequisite objects:

- A nPod running a VMware cluster
- Virtual Kubernetes cluster running on the physical vSphere cluster

Example Execution
-----------------

To execute this playbook, run the following command:

    ansible-playbook -i inventory/<some_inventory>.yml playbooks/ansible-playbook-nebulon-timejump/homewrecker.yml

