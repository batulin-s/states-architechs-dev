
{% if 'architechs' not in pillar.get('users_from_db')['groups'].keys() %}
architechs:
  group.present:
    - gid: 1000
{% endif %}

{% for g_name, gid in pillar['users_from_db']['groups'].items() %}
{{g_name}}:
  group.present:
    - gid: {{ gid }}
{% endfor %}

{% if pillar['users_from_db']['root_ssh_public'] %}
root_ssh:
  ssh_auth.present:
    - user: root
    - name: {{pillar['users_from_db']['root_ssh_public']}}
{% endif %}

{% for i in pillar.get('users_from_db')['users'] %}
{{i.name}}:
  user.present:
    - uid: {{i.get('uid')}}
    - shell: {{i.get('shell')}}
    - home: {{i.get('home')}}
    - gid: {% if i.get('sudo') %}1001{% else %} 1002{% endif %}
  ssh_auth.present:
    - user: {{ i.username }}
    - names: {{ i.ssh_public.split('\r\n') }}

{% endfor %}
{% for i in pillar.get('users_from_db')['architechs'] %}
{{ i.username }}:
  user.present:
    - uid: {{ i.get('uid') }}
    - shell: {{ i.get('shell')}}
    - home: {{i.get('home')}}
    - gid: 1000
    - groups:
      - wheel
  ssh_auth.present:
    - user: {{ i.username }}
    - names: {{ i.ssh_public.split('\r\n') }}
{% endfor %}
