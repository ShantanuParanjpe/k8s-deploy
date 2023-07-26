pipeline {
  agent any
  environment {
     DOCKER_REGISTRY = 'https://registry-1.docker.io/v2/'
     DOCKER_IMAGE_NAME = 'nginx'
     DOCKER_IMAGE_TAG = 'latest'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
         sh 'docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .'
         }
    }
    
    
    stage('Login') {
      steps {
         script {
            withCredentials([usernamePassword(credentialsId: 'shaan-dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
         }
      }
    }
    }

    stage('Push Docker Image') {
      steps {
        script {
          docker.withRegistry("${DOCKER_REGISTRY}") {
              def dockerImage = docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
              dockerImage.push()
        }
      }
    }
    }

    stage('Deploy to K8s with Ansible') {
      steps {
        sh  'ansible-playbook -i inventory_aws_ec2.yaml playbook.yml'
      }
    }
  }
}

