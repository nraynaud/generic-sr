#!/usr/bin/env bash

set -ex

BUILD_MACHINE=debian@192.168.100.158

VERSION=1.0
ARTIFACT=generic-sr_${VERSION}.rpm


ssh ${BUILD_MACHINE} "rm -rf generic-sr"
rsync -v  --exclude '.*' --exclude '.*\.rpm' -r . ${BUILD_MACHINE}:generic-sr
ssh ${BUILD_MACHINE} "cd generic-sr; ls"
ssh ${BUILD_MACHINE} "cd generic-sr; fpm -s dir -v ${VERSION} --after-install post-install.sh --description 'generic SR plugin' --url NONE --license 'GNU AFFERO GENERAL PUBLIC LICENSE' --vendor VATES -t rpm -n generic-sr -f -p ${ARTIFACT} -C SOURCES ."
ssh ${BUILD_MACHINE} "cd generic-sr; rpm -qpli ${ARTIFACT}"
rsync -v ${BUILD_MACHINE}:generic-sr/${ARTIFACT} .