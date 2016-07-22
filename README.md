Role Name
=========
[![Build Status](https://travis-ci.org/pbonrad/ansible-influxdb.svg?branch=master)](https://travis-ci.org/pbonrad/ansible-influxdb)

InfluxDB is an open source database written in Go specifically to handle time series data with high availability and high performance requirements. InfluxDB installs in minutes without external dependencies, yet is flexible and scalable enough for complex deployments.

More information can be found on the webpage: [https://influxdata.com/time-series-platform/influxdb/](https://influxdata.com/time-series-platform/influxdb/)

The role works for Ubuntu and Debian and was tested with the help of docker containers. In comparison to other Ansible role tests where Ansible runs inside the container and is connecting to localhost, I decided to use the [Ansible docker connection](http://docs.ansible.com/ansible/intro_inventory.html#non-ssh-connection-types). The build which run at [Travis CI](https://travis-ci.org/pbonrad/ansible-influxdb) uses this functionality.

See also: [https://github.com/pbonrad/ansible-docker-base](https://github.com/pbonrad/ansible-docker-base)

Role Variables
--------------

TODO: add more information to the default configuration.

If you need detailed information about the configuration for InfluxDB you should have a look at the official documentation:
- [Sample configuration](https://github.com/influxdata/influxdb/blob/master/etc/config.sample.toml)
- [Documentation](https://docs.influxdata.com/influxdb/v0.13/administration/config/)

Dependencies
------------

There are no dependencies to other roles. If you want to run the test, you need to install [Docker](https://www.docker.com/).

Example Playbook
----------------

An example playbook is included in the `test.yml` file. You can use `run.sh` for running a test locally, which starts a docker container as the target.

    - hosts: all
      roles:
         - role: ansible-influxdb

Contributions and Feedback
--------------------------
Any contributions are welcome. For any bugs or feature requests, please open an issue through [Github](https://github.com/pbonrad/ansible-influxdb/issues).

License
-------

MIT

Author Information
------------------

Peter Bonrad - [pbonrad](https://github.com/pbonrad) - 2016
