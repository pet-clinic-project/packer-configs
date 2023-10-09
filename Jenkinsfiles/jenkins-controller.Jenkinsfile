@Library('jenkins-shared-library@develop') _

pipeline {
    agent {
        docker {
            image '814200988517.dkr.ecr.us-west-2.amazonaws.com/infra-images:packer-1.0.4'
            args '-v /var/run/docker.sock:/var/run/docker.sock --privileged -u root'
            reuseNode true
        }
    }

    stages {
        stage('Validate') {
            steps {
                script {
                    def packerFilePath = 'jenkins-controller/jenkins-controller.pkr.hcl'
                    packerValidation(packerFilePath)
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    def packerFilePath = 'jenkins-controller/jenkins-controller.pkr.hcl'
                    packerBuild(packerFilePath)
                }
            }
        }
    }
}
