pipeline {
  agent any
  
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-key')
    AWS_SECRET_ACCESS_KEY = credentials('aws-key')
    AWS_DEFAULT_REGION = 'us-west-2'
 } 
  stages {
    stage("Checkout") {
      steps {
        git branch: 'main', url: 'https://github.com/ShantanuParanjpe/shaanrepo.git'
      }
    }
    
    stage("Terraform Init") {
      steps {
        sh "terraform init"
      }
    }
    
    stage("Terraform Plan") {
      steps {
        sh "terraform plan -out=tfplan"
      }
    }
    
    stage("Terraform Apply") {
      steps {
        input "Deploy infrastructure? (type 'yes' to proceed)"
        sh "terraform apply -auto-approve tfplan"
      }
    }
    
    stage("Show Instance IPs") {
      steps {
        script {
          def instance_ips = sh(script: "terraform output -raw instance_ips", returnStdout: true).trim()
          echo "Instance IPs: ${instance_ips}"
        }
      }
    }
  }
}

