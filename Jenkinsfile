pipeline {
  agent any
  
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker-token')
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
          withCredentials([usernamePassword(credentialsId: docker-token , variable: 'DOCKERHUB_TOKEN')]) {
           sh 'docker build -t shantanu1990/test:latest .'
         }
      }
   }
	
    stage('Login') {
      steps {
	    script {
          withCredentials([usernamePassword(credentialsId: docker-token , variable: 'DOCKERHUB_TOKEN')]) {
           sh 'docker login -u shantanu1990 -p $DOCKERHUB_TOKEN'
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
