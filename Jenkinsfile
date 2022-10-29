pipeline {
  agent {

    docker {
      //it's necessary to grant the user 'jenkins' permission to a docker: 'usermod -a -G docker jenkins'
      image 'hub.tolstykh.family/build-java:v0.1.1'
      args '-v /var/run/docker.sock:/var/run/docker.sock --privileged'
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

    stage('Make docker image') {
      steps {
        sh 'cd /tmp/build && docker build --tag=java-app .'
        sh 'docker tag java-app hub.tolstykh.family/java-app:v0.1.0 && docker push hub.tolstykh.family/java-app:v0.1.0'
      }
    }

    stage('Run docker on remote docker host') {
      steps {
//        sh 'ssh-keyscan -H 158.160.0.11 >> ~/.ssh/known_hosts'
//        sh '''ssh jenkins@158.160.0.11 << EOF
//	sudo docker pull devcvs-srv01:5000/shop2-backend/gateway-api:2-staging
//	cd /etc/shop/docker
	sh 'sudo docker run -h tcp://158.160.18.82:22375 -d --pull always hub.tolstykh.family/java-app:v0.1.0'
//EOF'''
      }
    }

  }
//  triggers {
//    pollSCM('*/1 H * * *')
//  }
  
}
