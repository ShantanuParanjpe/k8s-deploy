pipeline {
  agent any
  environment {
     DOCKER_REGISTRY = 'shantanu1990'
     DOCKER_IMAGE_NAME = 'nginx'
     DOCKER_IMAGE_TAG = 'latest'
     registryCredential = 'shaan-dockerhub'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
         sh 'docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .'
         }
    }
    
    stage('Push Docker Image') {
      steps {
        script {
            withCredentials([usernamePassword(credentialsId: 'shaan-dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
              sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
              sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
          }
      }
     }
    }

    stage('Create Secret object with Ansible') {
      steps {
         withCredentials([
             sshUserPrivateKey(credentialsId: 'aws-credentials', keyFileVariable: 'SSH_PRIVATE_KEY_FILE', usernameVariable: 'SSH_USER')]) {
             sh  '''
             mkdir -p $WORKSPACE/.ssh
             cp $SSH_PRIVATE_KEY_FILE $WORKSPACE/.ssh/id_rsa
             chmod 600 $WORKSPACE/.ssh/id_rsa
             chmod 700 $WORKSPACE/.ssh
             ansible-playbook -i inventory_aws_ec2.yaml secret.yml --private-key=$WORKSPACE/.ssh/id_rsa --user=$SSH_USER --ssh-common-args='-o StrictHostKeyChecking=no'
             '''
      }
     }
    }
  }
}

