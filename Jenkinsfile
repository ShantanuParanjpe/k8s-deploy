pipeline{
    agent any

stages {
   stage('Git Checkout') {
       steps {
         git'https://github.com/ShantanuParanjpe/shaanrepo.git'
       }
   }   

   
   stage('K8s Deploy') {
       steps {
          script {
            kubernetesDeploy(configs: "/Users/shaan/shaanrepo/dep.yml", kubeconfigId: "mykubeconfig")
                }
            }
        }
    }
}
