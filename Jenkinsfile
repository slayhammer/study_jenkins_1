pipeline {
  agent {

    docker {
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

/*    stage('Make docker image') {
      steps {
        sh 'mkdir /tmp/build && cp -R target/*.war /tmp/build && cd /tmp/build && docker build --tag=gateway-api .'
        sh '''docker tag gateway-api devcvs-srv01:5000/shop2-backend/gateway-api:2-staging && docker push devcvs-srv01:5000/shop2-backend/gateway-api:2-staging'''

      }
    }

    stage('Run docker on devbe-srv01') {
      steps {
        sh 'ssh-keyscan -H devbe-srv01 >> ~/.ssh/known_hosts'
        sh '''ssh jenkins@devbe-srv01 << EOF
	sudo docker pull devcvs-srv01:5000/shop2-backend/gateway-api:2-staging
	cd /etc/shop/docker
	sudo docker-compose up -d
EOF'''
      }
    }
*/
  }
//  triggers {
//    pollSCM('*/1 H * * *')
//  }
  
}
