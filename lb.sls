
sys-cluster/ipvsadm:
  pkg.installed

sys-cluster/keepalived:
  pkg.installed

lo:0:
  network.system:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: 192.168.50.100
    - netmask: 255.255.255.255
  

#try_lvs_service:
#  lvs_service.present:
#    - protocol: tcp
#    - service_address: 192.168.100.200:80

try_lvs_server_dev03:
  lvs_server.present:
    - protocol: tcp
    - service_address: 192.168.50.100:80
    - server_address: 192.168.50.3:80
    - weight: 100
try_lvs_server_dev02:
  lvs_server.present:
    - protocol: tcp
    - service_address: 92.168.50.100:80
    - server_address: 192.168.50.4:80
