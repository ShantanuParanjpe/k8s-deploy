pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
        DOCKER_IMAGE_NAME = 'shantanu1990/nginx'
        DOCKER_IMAGE_TAG = 'latest'    
        DOCKER_CONFIG_JSON = credentials('docker-config-json')
        DOCKER_CREDENTIALS = credentials('docker-creds')
        K8S_SECRET_NAME = 'docker-secret'
        K8S_NAMESPACE = 'default'		
    }
    
    stages {
        stage('Git Clone') {
            steps {
               checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], userRemoteConfigs: [[url: 'https://github.com/ShantanuParanjpe/shaanrepo.git']]]) 
            }
        }
        
        stage('Pull Docker Image') {
            steps {
                script {                   
                      withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD \$DOCKER_REGISTRY
                        docker pull \$DOCKER_REGISTRY/\$DOCKER_IMAGE
                        """
                    }
                }
            }
        }
        
        stage('Tag the docker Image') {
            steps {
                 sh 'docker build -t shaan/nginx:latest .'
                }
        }
        
		
		
        stage('Push Docker Image') {
            steps {
                script {
                       withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh """
                        docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD \$DOCKER_REGISTRY
                        docker push \$DOCKER_REGISTRY/\$DOCKER_IMAGE
                        """
                    }
                }
            }
        }
		
	stage('SSH and Execute Commands on Remote Host') {
            steps {
                script {
                         withCredentials([usernamePassword(credentialsId: , passwordVariable: 'CREDENTIAL_PASS')]) {
                          sshScript(
						  remote: '192.168.56.112',
						  user: 'root',
						  password: env.CREDENTIAL_PASS,
                          script: '''
                              sh "echo ${DOCKER_CONFIG_JSON} | base64 --decode > docker-config.json"
							  sh "kubectl create secret generic ${K8S_SECRET_NAME} --from-file=docker-config.json --namespace=${K8S_NAMESPACE}"
							  sh "kubectl apply -f deployment.yml"
							  '''
                          )
                    }
                }
	    }
	}
   }
}
