pipeline {
  agent any
  
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker-token')
    SSH_CREDENTIALS = credentials('ssh-creds')
    K8S_SECRET_NAME = 'docker-secret'
    DOCKER_CONFIG_JSON = credentials('docker-config-json')
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
          withCredentials([string(credentialsId: 'docker-token' , variable: 'DOCKERHUB_TOKEN')]) {
           sh 'docker build -t shantanu1990/test:latest .'
         }
      }
   }
 }	
    stage('Login') {
      steps {
	    script {
          withCredentials([string(credentialsId: 'docker-token' , variable: 'DOCKERHUB_TOKEN')]) {
           sh "docker login -u shantanu1990 -p \$DOCKERHUB_TOKEN"
      }
    }
   }
 }
	
    stage('Push') {
      steps {
        sh 'docker push shantanu1990/test:latest'
      }
    }
  
   
    stage('SSH and Execute Commands on Remote Host') {
            steps {
                            sshagent(credentials : ['ssh-creds']) {
                                'ssh -o StrictHostKeyChecking=no root@192.168.56.112'; "/usr/bin/kubectl create secret generic \${K8S_SECRET_NAME} --from-file=/root/.docker/config.json";/usr/bin/kubectl apply -f deployment.yml
                          }
                      } 
                   }
               }
         
         }  

  post {
    always {
      sh 'docker logout'
    }
  }
}
