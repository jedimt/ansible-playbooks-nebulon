#IP Addresses
data_ip: 10.100.25.38
mgt_ip: 10.100.25.37
data_net: 10.100.25.38/22
mgt_net: 10.100.25.37/22
mgt_int: eno5
data_int: ens6f0np0
demopod: hpe
route: 10.100.24.0/22
mgt_route_table: 100
data_route_table: 101
dns: 10.100.24.11
domain: tme.nebulon.com
gateway4: 10.100.24.1

# VMware variables
vmotionip: "10.100.28.37"
vmotionnetmask: "255.255.255.0"
d0_vmnic: "vmnic0"
d1_vmnic: "vmnic1"