pipeline {
  agent any

   environment {
    AWS_CREDENTIALS = credentials('a9a21e90-f004-4f2e-bca1-dc97b669a8d2')
  }

  stages {
    stage("Checkout") {
      steps {
        git branch: 'main', url: 'https://github.com/ShantanuParanjpe/shaanrepo.git'
      }
    }

    stage("Terraform Init") {
      steps {
        withAWS(credentials: a9a21e90-f004-4f2e-bca1-dc97b669a8d2, region: 'us-west-2')
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
