#!/bin/sh

# Based On A Script By: Brandon Mitchell <public@bmitch.net>
# License: MIT
# Source Repo: https://github.com/sudo-bmitch/jenkins-docker

set -x

# configure script to call original entrypoint
set -- tini -- /usr/local/bin/jenkins.sh "$@"

# In Prod, this may be configured with a GID already matching the container
# allowing the container to be run directly as Jenkins. In Dev, or on unknown
# environments, run the container as root to automatically correct docker
# group in container to match the docker.sock GID mounted from the host.
if [ "$(id -u)" = "0" ]; then
    groupmod -g ${DOCKERGID}  -o docker
	groupadd -g ${JENKINSGID} -o jenkins
	useradd -g jenkins -G docker -m -N -u ${JENKINSUID} -c "Jenkins action account" jenkins
  # usermod -aG docker jenkins
  # Add call to gosu to drop from root user to jenkins user
  # when running original entrypoint
  set -- gosu jenkins "$@"
fi

# replace the current pid 1 with original entrypoint
exec "$@"
