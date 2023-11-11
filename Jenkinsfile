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
    
	stage('SonarQube Analysis') {
	  steps {
	     script {
			withSonarQubeEnv('sq1') {
                        sh "./gradlew sonarqube"
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
                    script {
                            sshagent(credentials : ['ssh-creds']) {
                             sh """
                             ssh -o StrictHostKeyChecking=no root@192.168.56.112 << EOF
							 echo \${DOCKER_CONFIG_JSON} | base64 --decode > /root/.docker/config.json
                             kubectl create secret generic \${K8S_SECRET_NAME} --from-file=/root/.docker/config.json
                             kubectl apply -f deployment.yml
                             kubectl get po
                             """
                             }
                          }
                      }
                   }
				   
	stage('Docker Logout') {
      steps {
        sh 'docker logout'
      }
    }
  }

}
