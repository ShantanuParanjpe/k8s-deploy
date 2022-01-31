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
<<<<<<< HEAD
            kubernetesDeploy(configs: mynginx.yml, kubeconfigId:'mykubeconfig')
=======
            kubernetesDeploy(configs: mynginx.yml, kubeconfigId:'K8S')
>>>>>>> fabaabc2e7a4426ddcbb877d44c8b3178e8690cc
                }
            }
        }
    }
<<<<<<< HEAD

=======
}
>>>>>>> fabaabc2e7a4426ddcbb877d44c8b3178e8690cc
