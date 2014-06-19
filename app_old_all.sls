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
    - source: salt://configs/apache/httpd.conf
    - template: jinja
    - require:
      - pkg: www-servers/apache


www-servers/nginx:
  pkg:
    - installed
  service:
    - running
    - name: nginx
    - enable: False
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

