DPN-SERVER
===

A Rails implementation of the DPN RESTful communication layer.

This role installs required system packages and creates the dpn-server
database. It supports creating an AWS RDS instance or a local Postgresql DB.
Previously existing non-RDS instances are currently not supported. Large parts
of the deployment (and updates) are handled by a separate
role `ansistrano-deploy`.

Some of the configuration has to be kept in Ansible as many variables create
dependencies to other services.


Requirements
------------
This role is designed to be deployed on a Ubuntu Linux system.
It requires rbenv and a webserver like Nginx or Apache. If you choose to not
run it's database on AWS RDS Postgresql needs to be installed first.

Role Variables
--------------

See defaults/main.yml

All variables default to local development values. For deployment on demo
or production systems these will have to be overwritten using group_vars
or host_vars.

Dependencies
------------

Role dependencies:
- common
- zzet.rbenv
- cd3ef.nginx-passenger
- carlosbuenosvinos.ansistrano-deploy

Example Playbook
----------------
-   hosts: pharos-server
    vars_files:
        - "group_vars/vault.yml"

    environment: "{{ruby_env}}"

    vars:
        playbook_name: pharos
        # TODO: This should be determined by the git repo name at deploy time
        ansistrano_deploy_to: "/var/www/{{ansible_fqdn}}/{{playbook_name}}"
        ansistrano_deploy_via: "git"
        ansistrano_git_repo: "git@github.com:APTrust/pharos.git"
        ansistrano_git_branch: "develop"
        ansistrano_git_private_key: "{{aptdeploy_sshkey_private}}"
        ansistrano_shared_paths: ["log"]
        ansistrano_keep_releases: 3
        ansistrano_before_symlink_shared_tasks_file: "roles/aptrust.pharos/tasks/before-symlink.yml"

        # Pharos Role
        pharos_app_root: "{{ ansistrano_deploy_to }}/current"
        pharos_environment: "{{ruby_env}}"
        pharos_local_db: false

        # NGINX Webserver
        nginx_vhosts:
          - listen: "80 default_server"
            server_name: "_"
            return: 301 https://$host$request_uri
          - listen: "443 ssl"
            server_name: "{{ansible_fqdn}}"
            root: "{{ ansistrano_deploy_to }}/current/public"
            access_log: "/var/log/nginx/{{ansible_fqdn}}_access.log"
            error_log: "/var/log/nginx/{{ansible_fqdn}}_error.log"
            extra_parameters: |
                passenger_enabled on;
                passenger_base_uri /;
                passenger_app_root {{ ansistrano_deploy_to }}/current;
                passenger_app_env {{ RAILS_ENV }};
                passenger_friendly_error_pages off;

                ssl    on;
                # SSL Chain if Nginx, SSL cert if Apache2
                ssl_certificate    {{ssl_chain_path}};
                ssl_certificate_key {{ ssl_key_path }};

        # RBenv
        rbenv:
          env: user
          version: v1.0.0
          ruby_version: 2.3.1
        rbenv_users: "{{system_default_user}}"

    # AWS CREDENTIALS
    #AWS_ACCESS_KEY_ID: "{{ var_aws_access_key_id }}"
    #AWS_SECRET_ACCESS_KEY: "{{ var_aws_secret_access_key }}"

    #AWS_SES_USER: ""
    #AWS_SES_PASSWORD: ""

    roles:
      - {role: common, tags: common}
      - {role: oracle-java8, tags: oracle-java8 }
      - {role: zzet.rbenv, tags: rbenv}
      - {role: cd3ef.nginx-passenger, tags: [nginx, passenger, nginx-passenger]}
      - {role: carlosbuenosvinos.ansistrano-deploy, tags: deploy}
      - {role: aptrust.pharos, tags: pharos}

License
-------

MIT
