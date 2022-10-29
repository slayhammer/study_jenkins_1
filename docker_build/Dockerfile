# This is an java app building container image.

# Based on 'ubuntu' ver. 20.04 Official Docker Image
FROM ubuntu:20.04

# Environment setup
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Seting up all necessary software but docker:
#	'git'       - for cloning the sample java app from a rep
#	'maven'     - for building the app
#	'docker-ce' - for building prod container
RUN apt-get update && apt-get install -y \
	sudo \
	apt-transport-https \
	curl \
	gnupg2 \
	software-properties-common \
	git \
	maven

# Add docker engine repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
	&& add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Setting up docker and further cache cleaning:
RUN apt-get update && apt-get install -y \
	docker-ce \
	&& rm -rf /var/lib/apt/lists/*	

# RUN useradd -g users -G docker,sudo -d /home/jenkins -u 109 -c "Jenkins action account" jenkins

# Install ssh
# RUN apt-get -y install openssh-client

# Configure ssh client
# COPY id_rsa /root/.ssh/id_rsa
# RUN chmod 600 /root/.ssh/id_rsa
