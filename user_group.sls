architechs_admins:
  group.present:
    - gid: 1001
{% for arch_admin in pillar.get('architechs') %}
{{ arch_admin['username'] }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ arch_admin['username'] }}
    - uid: {{ arch_admin['uid'] }}
    - password: {{ arch_admin['hash_pwd'] }}
    - gid: 1001
    - enforce_password: False
    - groups:
      - root
{% endfor %}

{{ pillar['project_name'] }}_admins:
  group.present:
    - gid: 1002
{% for c_admin in pillar.get('admins') %}
{{ c_admin['username'] }}:
  user.present:
    - shell: /bin/bash
    - home: /home/{{ c_admin['username'] }}
    - uid: {{ c_admin['uid'] }}
    - password: {{ c_admin['hash_pwd'] }}
    - gid: 1002
    - enforce_password: False
    - groups:
      - wheel
{% endfor %}
{{ pillar['project_name'] }}_users:
  group.present:
    - gid: 1003
{% for customer in pillar.get('customers') %}
{{ customer['username'] }}:
  user.present:
    - shell: /bin/bash
    - password: {{ customer['hash_pwd'] }}
    - home: /home/{{ customer['username'] }}
    - gid: 1003
    - enforce_password: False
    - groups:
      - users
  {% if customer.get('pub_ssh_key') %}
  ssh_auth.present:
    - user: {{ customer['username'] }}
    - name: {{ customer['pub_ssh_key'] }}
  {% endif %}
{% endfor %}
