#IP Addresses
data_ip: 10.100.25.53
mgt_ip: 10.100.25.52
data_net: 10.100.25.53/22
mgt_net: 10.100.25.52/22
mgt_int: eno1
data_int: ens3f0np0
data_int_2: ens3f1np1
demopod: lenovo
route: 10.100.24.0/22
mgt_route_table: 100
data_route_table: 101
dns: 10.100.24.11
domain: tme.nebulon.com
gateway4: 10.100.24.1

# VMware variables
vmotionip: "10.100.28.52"
vmotionnetmask: "255.255.255.0"
d0_vmnic: "vmnic0"
d1_vmnic: "vmnic1"