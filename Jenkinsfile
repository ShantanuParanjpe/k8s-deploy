pipeline {
  agent any

  environment {
    TF_CLI_ARGS = "-no-color"
    AWS_ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
    AWS_SEC_KEY = credentials('AWS_SECRET_KEY')

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
  }
}
