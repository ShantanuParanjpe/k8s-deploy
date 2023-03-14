pipeline {
  agent any
  
  stages {
    stage("Checkout") {
      steps {
        git branch: 'main', url: 'https://github.com/ShantanuParanjpe/shaanrepo.git, credentialsId: 'aws-key''
      }
    }
    
    stage("Login to AWS") {
      steps {
         withCredentials([awsAccessKey(credentialsId: 'aws-key', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) 
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

