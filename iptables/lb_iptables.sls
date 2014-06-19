check_chain_IPVS:
  iptables.chain_present:
    - name: IPVS
    - table: mangle
check_chain_mark:
  iptables.chain_present:
    - name: MARKING
    - table: mangle
IPVS_marks:
  iptables.append:
    - table: mangle
    - chain: IPVS
    - destination: 192.168.50.100/32
    - in-interface: eth0
    - proto: tcp
    - match: tcp
    - dport: 80
    - jump: MARKING
MARK_append:
  iptables.append:
    - table: mangle
    - chain: MARKING
    - set-mark: 1

{#{% for lb in pillar['hwaddr_interfaces'].keys() %}
{% for mac in [grains['hwaddr_interfaces']['eth0']] %}
run_rules_for_{{ mac }}:
  iptables.append:
    - table: mangle
    - chain: IPVS
    - jump: RETURN
    - match: mac
    - mac-source: {{ mac }}
    - save: False
  {% endfor %}
  {% endfor %}#}
