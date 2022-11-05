#!/bin/sh

set -x

groupmod -og ${DOCKERGID}  docker
groupadd -og ${JENKINSGID} jenkins
useradd -g jenkins -G docker -m -N -u ${JENKINSUID} -c "Jenkins action account" jenkins
