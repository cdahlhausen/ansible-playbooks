Centrallogs
===

This role moves application logs to a central log directory and symlinks the
applications original log directory. This will ensure persistence and
automated logrotation to remain intact.

This role is a stop-gap in lieu of proper log aggregation service or rsyslog
setup.

Requirements
------------
This role is designed to be deployed on a Ubuntu Linux system.


Role Variables
--------------

See defaults/main.yml

centrallogs: Application that produces the logs. A subdirectory in the central log location
 will be created.

app_log_dir: Directory to symlink in central log directory. e.g. /var/log/nginx

central_log_dir: Central log directory to move logfiles to.

Dependencies
------------

None.

Example Playbook
----------------
-   hosts: all
    vars_files:
      - "group_vars/vault.yml"
    vars:
        playbook_name: 'oneoff'
        # Defined in all.yml and
        # mount_dir: /mnt/efs/apt
        # central_log_dir: "{{mount_dir}}/{{orgtype}}/logs/{{ansible_hostname}}"

        centrallogs:
          - { name: nginx, logdir: /var/log/nginx, servicename: nginx}
          - { name: unattended-upgrades, logdir: /var/log/unattended-upgradescopy }
          - {name: pharos, logdir: "/var/www/{{ansible_fqdn}}/pharos/shared/log", servicename: nginx}

    roles:
      - { role: common, tags: common}
      - { role: central_logs, tags: centrallogs}

License
-------

MIT
