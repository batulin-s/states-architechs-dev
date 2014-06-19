mail-mta/postfix:
  pkg:
    - installed
  service:
    - running
    - name: postfix
    - enable: True
    - watch:
      - pkg: mail-mta/postfix
      - file: /etc/postfix/main.cf

/etc/postfix/main.cf:
  file.managed:
    - source: salt://configs/postfix/main.cf
    - template: jinja
    - require:
      - pkg: mail-mta/postfix

