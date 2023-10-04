pipeline {
    agent {
        docker {
            image '814200988517.dkr.ecr.us-west-2.amazonaws.com/infra-images:packer-1.0.4'
            args '-v /var/run/docker.sock:/var/run/docker.sock --privileged'
            }
    }

    stages {
        stage('Packer Validate') {
            steps {
                script {
                    sh "packer validate jenkins-controller/jenkins-controller.pkr.hcl"
                }
            }
        }
    }
}