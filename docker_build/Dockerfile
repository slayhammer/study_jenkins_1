# This is an java app building container image.

# Based on 'ubuntu' ver. 20.04 Official Docker Image
FROM ubuntu:20.04

# Environment setup
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Seting up all necessary software but docker:
#   first 4 pkgs - for adding docker engine package repository
#	'git'        - for cloning the sample java app from a rep
#	'maven'      - for building the app
RUN apt-get update && apt-get install -y \
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

# Enprypoint to sync jenkins user context for getting neccessary permissions
# and to behave as jenkins expects
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
