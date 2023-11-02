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
                script {
                    withCredentials([usernamePassword(credentialsId: SSH_CREDENTIALS, passwordVariable: 'CREDENTIAL_PASS')]) {
                        sshScript(
                            remote: '192.168.56.112',
                            user: 'root',
                            password: env.CREDENTIAL_PASS,
                            script: """
                                echo \${DOCKER_CONFIG_JSON} | base64 --decode > docker-config.json
                                kubectl create secret generic \${K8S_SECRET_NAME} --from-file=docker-config.json --namespace=\${K8S_NAMESPACE}
                                kubectl apply -f deployment.yml
                                """
                              )
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
