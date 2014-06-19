www-servers/lighttpd:
  pkg:
    - installed
  service:
    - running
    - name: lighttpd
    - enable: False
    - watch:
      - pkg: www-servers/lighttpd
      - file: /etc/lighttpd/lighttpd.conf

/etc/lighttpd/lighttpd.conf:
  file.managed:
    - source: salt://configs/lighttpd/lighttpd.conf
    - template: jinja
    - require:
      - pkg: www-servers/lighttpd
