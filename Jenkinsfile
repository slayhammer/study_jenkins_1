pipeline {
	agent {
		docker {
		//'dockerd' daemon at target host must be set up and available for jenkins host. 
		//It's necessary to grant the user 'jenkins' permission to a docker:
		//  'usermod -a -G docker jenkins'
		//  'chmod 666 /var/run/docker.sock' (every time after jenkins host restarts)
			image 'hub.tolstykh.family/build-java:v0.1.7'
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
		}
	}
	
	stage('Nexus login') {
		steps {
			withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'NEXUS_PWD', usernameVariable: 'NEXUS_USER')]) {
				sh 'printenv NEXUS_PWD | docker login -u $NEXUS_USER --password-stdin hub.tolstykh.family'
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
			sh 'docker run -h tcp://158.160.16.181:22375 -d --pull always hub.tolstykh.family/java-app:v0.1.0'
		}
	}

}

}
