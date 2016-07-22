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

DISTRIBUTION=debian-7

echo "### Start docker hosts"
echo "Distribution: $DISTRIBUTION"
docker run -td --privileged --name ansible-$DISTRIBUTION pbonrad/ansible-docker-base:$DISTRIBUTION

echo "### Starting tests"
echo "ansible-$DISTRIBUTION ansible_connection=docker" > tests/inventory
ansible-playbook -i tests/inventory tests/test.yml --syntax-check
ansible-playbook -i tests/inventory tests/test.yml

sleep 15
CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' ansible-$DISTRIBUTION)

curl -POST http://$CONTAINER_IP:8086/query \
--data-urlencode "q=CREATE DATABASE mydb"

curl -XPOST "http://$CONTAINER_IP:8086/write?db=mydb" \
-d 'cpu,host=server01,region=uswest load=42 1434055562000000000'

curl -XPOST "http://$CONTAINER_IP:8086/write?db=mydb" \
-d 'cpu,host=server02,region=uswest load=78 1434055562000000000'

curl -XPOST "http://$CONTAINER_IP:8086/write?db=mydb" \
-d 'cpu,host=server03,region=useast load=15.4 1434055562000000000'

curl -G http://$CONTAINER_IP:8086/query?pretty=true --data-urlencode "db=mydb" \
--data-urlencode "q=SELECT * FROM cpu WHERE host='server01' AND time < now() - 1d"

echo "### Clean up"
docker stop ansible-$DISTRIBUTION
docker rm ansible-$DISTRIBUTION
rm tests/inventory
