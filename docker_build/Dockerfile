# This is an java app building container image.

# Based on 'ubuntu' ver. 20.04 Official Docker Image
FROM ubuntu:20.04

# Environment setup
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Add docker engine repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Seting up all necessary software and further cache cleaning:
#	'git'       - for cloning the sample java app from a rep
#	'maven'     - for building the app
#	'docker-ce' - for building prod container
RUN apt-get update && apt-get install -y \
	gnupg2 \
	git \
	maven \
	docker-ce \
	&& rm -rf /var/lib/apt/lists/*	

# Install ssh
# RUN apt-get -y install openssh-client

# Confugure ssh client
# COPY id_rsa /root/.ssh/id_rsa
# RUN chmod 600 /root/.ssh/id_rsa

# RUN apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

