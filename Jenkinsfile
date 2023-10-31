pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'https://hub.docker.com/u/shantanu1990'
        DOCKER_IMAGE_NAME = 'nginx'
        DOCKER_IMAGE_TAG = 'latest'    
        DOCKER_CONFIG_JSON = credentials('docker-config-json')
        K8S_SECRET_NAME = 'docker-secret'
        K8S_NAMESPACE = 'default'		
		remoteServer = 'your_server_ip_or_hostname'
		remoteUser = 'your_ssh_username'
		SSH_CREDS = credentials('ssh-creds')
    }
    
    stages {
        stage('Git Clone') {
            steps {
                git clone  https://github.com/ShantanuParanjpe/shaanrepo.git
            }
        }
        
        stage('Pull Docker Image') {
            steps {
                script {                   
                    docker.withRegistry("${DOCKER_REGISTRY}") {
                        def dockerImage = docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                        dockerImage.pull()
                    }
                }
            }
        }
        
        stage('Tag the docker Image') {
            steps {
                 sh 'docker build -t shaan/nginx:latest .'
                }
            }
        }
        
		
		
        stage('Push Docker Image') {
            steps {
                script {
                    // Push the new Docker image to the registry using the credentials
                    docker.withRegistry("${DOCKER_REGISTRY}") {
                        def dockerImage = docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                        dockerImage.push()
                    }
                }
            }
        }
		
		stage('SSH and Execute Commands on Remote Host') {
            steps {
                script {
                         withCredentials([usernamePassword(credentialsId: ssh-creds, passwordVariable: 'CREDENTIAL_PASS')]) {
                          sshScript(
						  remote: 192.168.56.112,
						  user: root,
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
