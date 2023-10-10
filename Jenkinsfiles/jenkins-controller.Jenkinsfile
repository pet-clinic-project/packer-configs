@Library('jenkins-shared-library@develop') _

pipeline {
    agent {
        docker {
            image '814200988517.dkr.ecr.us-west-2.amazonaws.com/infra-images:packer-1.0.14'
            args '-v /var/run/docker.sock:/var/run/docker.sock --privileged -u root'
            reuseNode true
        }
    }

    stages {
        stage('Validate') {
            steps {
                script {
                    def packerFile = 'jenkins-controller.pkr.hcl'
                    def projectDir = 'jenkins-controller'
                    packerValidation(
                        packerFile,
                        projectDir
                    )
                }
            }
        }
    }
}
