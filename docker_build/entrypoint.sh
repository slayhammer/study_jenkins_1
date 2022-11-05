#!/bin/sh

# Environment settings
set -x

# Sync jenkins user context for getting neccessary permissions
groupmod -og ${DOCKERGID}  docker
groupadd -og ${JENKINSGID} jenkins
useradd -g jenkins -G docker -m -N -u ${JENKINSUID} -c "Jenkins action account" jenkins

# Set script behavior as jenkins expects (endless waiting for stdin input)
set -- gosu jenkins "$@"
sleep 1d
