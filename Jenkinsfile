//JENKINS HOST REQUIREMENTS:
//	- CA certificates from rep must be installed;
//  - It's necessary to grant the user 'jenkins' permission to a docker:
//  	'usermod -a -G docker jenkins'
//
//DOCKER HOST REQUIREMENTS:
//	- CA certificates from rep must be installed;
//	- 'dockerd' daemon at target host must be set up and available for jenkins host.

pipeline {
	agent any
	environment {
	    JENKINSUID = """${sh(
	    				returnStdout: true,
	    				script: 'id -u jenkins'
	    			)}"""

	    JENKINSGID = """${sh(
	    				returnStdout: true,
	    				script: 'id -g jenkins'
	    			)}"""

	    DOCKERGID  = """${sh(
	    				returnStdout: true,
	    				script: 'stat -c %g /var/run/docker.sock'
	    			)}"""
	}
	stages {
		stage('Build and deploy the app') {
			agent {
				docker {
					image 'hub.tolstykh.family/build-java:latest'
					args '-v /var/run/docker.sock:/var/run/docker.sock --group-add docker -e JENKINSUID -e JENKINSGID -e DOCKERGID'
				}
			}

			stages {
	    		stage('Debug section') {
	    			steps {
	    				echo "${env.JENKINSUID}"
	    				echo "${env.JENKINSGID}"
	    				echo "${env.DOCKERGID}"	
	    				sh 'cat /etc/passwd'
	    				sh 'cat /etc/group'
	    				sh 'cat /tmp/useradd.log'
	    			}
        		}

				stage('Copy source with configs') {
					steps {
						git(url: 'https://github.com/ashburnere/onlineshop-war.git', branch: 'master', poll: true)
					}
				}

				stage('Build war') {
					steps {
						sh 'mvn package'
						sh 'mkdir /tmp/build; cp -f target/onlineshop.war /tmp/build/'
					}
				}

				stage('Copy source with prod Dockerfile') {
					steps {
						sh 'mkdir /tmp/prod-rep; cd /tmp/prod-rep'
						git(url: 'https://github.com/slayhammer/study_jenkins_1.git', branch: 'master', poll: true)
						sh 'cp -f Dockerfile /tmp/build/'
					}
				}
	
				stage('Nexus login') {
					steps {
						withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USER')]) {
						sh 'docker login -u $NEXUS_USER -p $NEXUS_PWD hub.tolstykh.family'
						}
					}
				}
	
				stage('Make docker image') {
					steps {
						sh 'cd /tmp/build && docker build --tag=java-app .'
						sh 'docker tag java-app hub.tolstykh.family/java-app:v0.1.0 && docker push hub.tolstykh.family/java-app:v0.1.0'
					}
				}

				stage('Run docker on remote docker host') {
					steps {
						sh 'docker -H tcp://84.201.139.106:22375 run -d --pull always -p 8080:8080 hub.tolstykh.family/java-app:v0.1.0'
					}
				}

			}

		}
	}

}