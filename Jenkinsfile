pipeline {
  agent any
  
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker-creds')
  }
  stages {
    stage('Git Clone') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'main']], doGenerateSubmoduleConfigurations: false, extensions: [], userRemoteConfigs: [[url: 'https://github.com/ShantanuParanjpe/shaanrepo.git']]])
            }
        }
		
    stage('Build') {
      steps {
	    script {
          withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS , usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKER_CREDENTIALS_PSW')]) {
           sh 'docker build -t shantanu1990/test:latest .'
      }
    }
   }
 }
	
    stage('Login') {
      steps {
	    script {
          withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS , usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKER_CREDENTIALS_PSW')]) {
           sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
     }
    }
  }
	
    stage('Push') {
      steps {
        sh 'docker push shantanu1990/test:latest'
      }
    }
  }
  
  post {
    always {
      sh 'docker logout'
    }
  }
}
