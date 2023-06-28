pipeline {
  agent any

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
  }
}
