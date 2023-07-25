pipeline {
  agent any
  environment {
     DOCKER_REGISTRY = 'https://hub.docker.com/u/shantanu1990'
     DOCKER_IMAGE_NAME = 'nginx'
     DOCKER_IMAGE_TAG = 'latest'
  }

  stages {
    stage('Checkout') {
      steps {
        git clone  https://github.com/ShantanuParanjpe/shaanrepo.git
      }
    }

    stage('Build Docker Image') {
      steps {
         sh 'docker build -t shaan/nginx:latest .'
         }
    }
    }
    
    stage('Login') {
      steps {
         script {
          docker.withCredentials("${DOCKER_REGISTRY}", 'shaan-dockerhub')
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

    stage('Deploy to K8s with Ansible') {
      steps {
         ansible-playbook -i inventory playbook.yml
      }
    }
  }
}
