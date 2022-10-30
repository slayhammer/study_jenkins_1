//JENKINS HOST REQUIREMENTS:
//	- CA certificates from rep must be installed;
//  - It's necessary to grant the user 'jenkins' permission to a docker:
//  	'usermod -a -G docker jenkins'
//  	'chmod 666 /var/run/docker.sock' (!!!every time after jenkins host restarts!!!)
//
//DOCKER HOST REQUIREMENTS:
//	- CA certificates from rep must be installed;
//	- 'dockerd' daemon at target host must be set up and available for jenkins host.

pipeline {
	agent {
		docker {
			image 'hub.tolstykh.family/build-java:latest'
			args '-v /var/run/docker.sock:/var/run/docker.sock'
		}
	}

stages {

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
			sh 'cat /etc/group' //debug
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
			sh 'docker -H tcp://158.160.16.181:22375 run -d --pull always --expose 8080:8080 hub.tolstykh.family/java-app:v0.1.0'
		}
	}

}

}
