# Misc demo playbooks

These playbooks are developed in an ad-hoc manner to support specific demo requests. In most cases these playbooks are not hardened and not guarenteed to be idempotent due to lack of development time as well as using pre-production features.

- **cloud-init-test-[hpe,lenovo].yml** - Uses pre-production Nebulon Ansible module (v1.5.0 alpha) to inject cloud-init state into the boot image for customization of the host OS during nPod deployment. This is an improvement in the sense that the nPod template can dynamically push state data into an existing image that has been suitably prepared. This enables more self-contained deployment images vs having to rely on external resources to customize hosts at first boot.
- **npod_failover.yml** - This was strung together to demonstrate cloning the boot volumes from a source nPod to a newly created target nPod as a proof of capability for disaster recovery use-cases.
- **switch-boot-lun.yml** - Uses a pre-production version of the Nebulon Ansible module to modify the boot volume for an existing nPod. Could be used in conjunction with Immutable Boot feature for upgrading hosts.
- **reset_hpe_demo_system.yml** - Helper playbook to reset TME systems after running the *npod_failover.yml* playbook.