#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

__DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
__BASE__="$(basename "${0}")"
__FILE__="${__DIR__}/${__BASE__}"

echo "################################"
echo "Build Information"
echo "Directory: ${__DIR__}"
echo "Filename: ${__FILE__}"
echo "Version Information:"
echo "Ansible Version: $(ansible --version)"
echo "Ansible Playbook Version: $(ansible-playbook --version)"
echo "Docker Version: $(docker --version)"
echo "Operating System: $(lsb_release -d | awk -F: '{ print $2 }' | tr -d '\t')"
echo "Kernel: $(uname -a)"
echo "################################"

export DISTRIBUTION=debian-7

echo "### Start docker hosts"
echo "Distribution: $DISTRIBUTION"
docker run -td --privileged --name ansible-$DISTRIBUTION pbonrad/ansible-docker-base:$DISTRIBUTION

echo "### Starting tests"
echo "ansible-$DISTRIBUTION ansible_connection=docker" > tests/inventory
ansible-playbook -i tests/inventory tests/test.yml --syntax-check
ansible-playbook -i tests/inventory tests/test.yml

CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' ansible-$DISTRIBUTION)
curl -POST http://$CONTAINER_IP:8086/query --data-urlencode "q=CREATE DATABASE mydb"
curl -i -XPOST "http://$CONTAINER_IP:8086/write?db=mydb" --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'

echo "### Clean up"
docker stop ansible-$DISTRIBUTION
docker rm ansible-$DISTRIBUTION
rm tests/inventory
