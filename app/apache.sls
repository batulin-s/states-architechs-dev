www-servers/apache:
  pkg:
    - installed
  service:
    - running
    - name: apache2
    - enable: True
    - require:
      - pkg: www-servers/apache
    - watch:
      - pkg: www-servers/apache
      - file: /etc/apache2/httpd.conf

/etc/apache2/httpd.conf:
  file.managed:
    #- source: salt://configs/apache/httpd.conf
    - source: /trysalt/httpd.conf
    - template: jinja
    - require:
      - pkg: www-servers/apache
/etc/apache2/modules.d/00_default_settings.conf:
  file.managed:
    - source: salt://configs/apache/00_default_settings.conf
    - template: jinja
    - require:
      - pkg: www-servers/apache
