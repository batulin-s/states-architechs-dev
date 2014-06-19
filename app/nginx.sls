www-servers/nginx:
  pkg:
    - installed
  service:
    - running
    - name: nginx
    - enable: True
    - require:
      - pkg: www-servers/nginx
    - watch:
      - pkg: www-servers/nginx
      - file: /etc/nginx/nginx.conf

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://configs/nginx/nginx.conf
    - template: jinja
    - require:
      - pkg: www-servers/nginx

