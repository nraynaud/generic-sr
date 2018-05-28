#!/usr/bin/env bash

set -ex

MASTER_HOST=root@192.168.100.11
SNAPSHOT_UUID=7ae9921d-d0db-c87c-ea7c-b3450fe8eeeb
VM_HOST_UNDER_TEST_UUID=13ec74c2-9b57-a327-962f-1ebd9702eec4
HOST_UNDER_TEST_UUID=05c61e28-11cf-4131-b645-a0be7637c044
XCP_HOST_UNDER_TEST_IP=192.168.100.151
XCP_HOST_UNDER_TEST=root@${XCP_HOST_UNDER_TEST_IP}

VERSION=1.0
ARTIFACT=generic-sr_${VERSION}.rpm

ssh ${MASTER_HOST} xe snapshot-revert snapshot-uuid=${SNAPSHOT_UUID}
ssh ${MASTER_HOST} xe vm-start vm=${VM_HOST_UNDER_TEST_UUID}
until ping -c1 ${XCP_HOST_UNDER_TEST_IP} &>/dev/null; do :; done
sleep 20
rsync -v  --exclude '.*' -r ${ARTIFACT} ${XCP_HOST_UNDER_TEST}:
ssh ${XCP_HOST_UNDER_TEST} "yum install -y ${ARTIFACT} && xe-toolstack-restart && grep sm-plugins /etc/xapi.conf && ls -l /opt/xensource/sm"
sleep 20
SR_UNDER_TEST_UUID=`ssh ${XCP_HOST_UNDER_TEST} "xe sr-create host-uuid=${HOST_UNDER_TEST_UUID} name-label=test-generic-sr type=generic device-config:location=/root/test"`
ssh ${XCP_HOST_UNDER_TEST}  "xe vdi-create sr-uuid=${SR_UNDER_TEST_UUID} name-label=test-vdi virtual-size=5368709120"
