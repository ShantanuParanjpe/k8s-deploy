pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        REPO_URL              = 'https://github.com/ShantanuParanjpe/k8s-deploy.git'
        TERRAFORM_DIR         = 'k8s-deploy/ppac-lab'
        OPA_POLICY            = 'policy.rego'
        PLAN_FILE             = 'tfplan.binary'
        PLAN_JSON             = 'plan.json'
    }
    stages {
        stage('Git Clone') {
            steps {
                echo '📥 Cloning Git repository...'
                sh """
                    rm -rf k8s-deploy
                    git clone -b feature-1 ${REPO_URL}
                """
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh """
                        echo '📝 Creating Terraform plan...'
                        terraform plan -out=${PLAN_FILE} -input=false
                        terraform show -json ${PLAN_FILE} > ${PLAN_JSON}
                    """
                }
            }
        }

        stage('OPA Policy Check') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    script {
                        echo '🔍 Evaluating OPA policy...'
                        def opaResult = sh(
                            script: "opa eval --input ${PLAN_JSON} --data ${OPA_POLICY} 'data.terraform.aws.deny' --format raw",
                            returnStdout: true
                        ).trim()
                        echo "OPA Result: ${opaResult}"
                        if (opaResult != "[]") {
                            error("❌ Policy violation detected! Blocking Terraform apply.")
                        } else {
                            echo "✅ Policy passed."
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    echo '🚀 Applying Terraform...'
                    sh 'terraform apply -auto-approve tfplan.binary'
                }
            }
        }
    }
    post {
        always {
            echo '🔹 Cleaning workspace...'
            deleteDir()
        }
    }
}
