check_chain_TRAF_ACCT_IN:
  iptables.chain_present:
    - name: TRAF_ACCT_IN
    - table: filter
check_chain_TRAF_ACCT_OUT:
  iptables.chain_present:
    - name: TRAF_ACCT_OUT
    - table: filter
{% for chain in pillar['iptables_conf_accept'].keys() %}
check_chain_{{ chain }}:
  iptables.chain_present:
    - name: {{ chain }}
    - table: filter
{% endfor %}
{# INPUT #}
rule_for_trafacctin:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: TRAF_ACCT_IN
rule_for_snmp-udp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: udp
    - match: udp
    - dport: 161
    - jump: snmp
rule_for_snmp-tcp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: tcp
    - match: tcp
    - dport: 161
    - jump: snmp
rule_for_127_0_0_0:
  iptables.append:
    - table: filter
    - chain: INPUT
    - source: 127.0.0.1/24
    - jump: ACCEPT
rule_for_conntrack:
  iptables.append:
    - table: filter
    - chain: INPUT
    - match: conntrack
    - ctstate: RELATED,ESTABLISHED
    - jump: ACCEPT
rule_for_input_ssh:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: tcp
    - match: tcp
    - dport: 22
    - jump: ssh
rule_for_input_nrpe:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: tcp
    - match: tcp
    - dport: 5666
    - jump: nrpe
rule_for_input_icmp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: icmp
    - jump: icmp_accept
rule_for_input_udp:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: udp
    - match: udp
    - dport: 123
    - jump: ntp
{% if pillar['iptables_conf_accept'].get('mysql') %}
rule_for_input_mmm:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: tcp
    - dport: 9989
    - match: tcp
    - jump: mmm
rule_for_input_mysql:
  iptables.append:
    - table: filter
    - chain: INPUT
    - proto: tcp
    - dport: 3306
    - match: tcp
    - jump: mysql
{% endif %}
{# OUTPUT #}
rule_for_output_traf_acct_out:
  iptables.append:
    - table: filter
    - chain: OUTPUT
    - jump: TRAF_ACCT_OUT
{# TRAF_ACCT_IN #}
rule_traf_acct_in1:
  iptables.append:
    - table: filter
    - chain: TRAF_ACCT_IN
    - source: 10.0.0.0/8
    - jump: RETURN
rule_traf_acct_in2:
  iptables.append:
    - table: filter
    - chain: TRAF_ACCT_IN
    - source: 83.140.104.0/22
    - jump: RETURN
rule_traf_acct_in3:
  iptables.append:
    - table: filter
    - chain: TRAF_ACCT_IN
    - jump: RETURN
{# TRAF_ACCT_OUT #}
rule_for_traf_acct_out1:
  iptables.append:
    - table: filter
    - chain: TRAF_ACCT_OUT
    - source: 83.140.104.0/22
    - jump: RETURN
rule_for_traf_acct_out2:
  iptables.append:
    - table: filter
    - chain: TRAF_ACCT_OUT
    - source: 10.0.0.0/8
    - jump: RETURN
rule_for_traf_acct_out3:
  iptables.append:
    - table: filter
    - chain: TRAF_ACCT_OUT
    - jump: RETURN

{% for chain in pillar['iptables_conf_accept'].keys() %}
{% for host in pillar['iptables_conf_accept'][chain] %}
rules_for_{{ chain }}_{{ host }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - source: {{ host }}
    - jump: ACCEPT
{% endfor %}
{% endfor %}
{# POLICY #}
rule_policy_output:
  iptables.set_policy:
    - table: filter
    - chain: OUTPUT
    - policy: ACCEPT
rule_policy_forward:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - policy: ACCEPT
rule_policy_input:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: DROP
{% if 'loadbalancer' in grains['roles'] %}
include:
  - iptables.lb_iptables
{% endif %}
