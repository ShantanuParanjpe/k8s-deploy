pipeline{
    agent {label 'kubepod'}

stages {
   stage('Git Checkout') {
       steps {
         git'https://github.com/ShantanuParanjpe/shaanrepo.git'
       }
   }   
}
   
    stage('K8s Deploy') {
        steps{
          script{
            kubernetesDeploy(configs: mynginx.yml, kubeconfigId:'mykubeconfig')
                }
            }
        }
    }

