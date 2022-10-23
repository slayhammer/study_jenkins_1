# This is a sample java app runtime package (https://github.com/ashburnere/onlineshop-war)
# wrapped in a docker container.
# Available at http://<your_address>:8080/onlineshop

# Based on 'alpine' ver. 3.16.2 Official Docker Image
FROM alpine:3.16.2

# Environment setup
ENV TZ=Europe/Moscow
ENV CATALINA_BASE /var/lib/tomcat9
ENV CATALINA_HOME $CATALINA_BASE
ENV PATH $CATALINA_HOME/bin:$CATALINA_BASE/bin:$PATH
RUN mkdir $CATALINA_BASE

# Seting up all necessary software and further cache cleaning:
#	'openjdk8-jre-base' - tomcat9 prereq
#	tomcat 9.0.68       - for hosting the app
RUN apk add --no-cache openjdk8-jre-base; \
	wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.68/bin/apache-tomcat-9.0.68.tar.gz; \
	tar xvzf apache-tomcat-9.0.68.tar.gz --strip-components 1 --directory $CATALINA_BASE; \
	rm -f apache-tomcat-9.0.68.tar.gz

# Installing the app
COPY onlineshop.war $CATALINA_BASE/webapps/

# Running environment
EXPOSE 8080
CMD ["catalina.sh", "run"]
