pipeline {
  agent {

    docker {
      //it's necessary to grant Jenkins permission to a Docker: 'usermod -a -G docker jenkins'
      image 'hub.tolstykh.family/build-java:v0.1.0'
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
      }
    }

    stage('Make docker image') {
      steps {
        sh 'docker build --tag=java-app .'
        sh 'docker tag java-app hub.tolstykh.family/java-app:v0.1.0 && docker push hub.tolstykh.family/java-app:v0.1.0'
      }
    }

    stage('Run docker on remote docker host') {
      steps {
//        sh 'ssh-keyscan -H 158.160.0.11 >> ~/.ssh/known_hosts'
//        sh '''ssh jenkins@158.160.0.11 << EOF
//	sudo docker pull devcvs-srv01:5000/shop2-backend/gateway-api:2-staging
//	cd /etc/shop/docker
	sh 'sudo docker run -h tcp://158.160.0.11:22375 -d --pull always hub.tolstykh.family/java-app:v0.1.0'
//EOF'''
      }
    }

  }
//  triggers {
//    pollSCM('*/1 H * * *')
//  }
  
}
