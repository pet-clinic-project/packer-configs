@Library('jenkins-shared-library@develop') _

pipeline {
    agent {
        docker {
            image '814200988517.dkr.ecr.us-west-2.amazonaws.com/infra-images:packer-1.0.24'
            args '-v /var/run/docker.sock:/var/run/docker.sock --privileged -u root'
            reuseNode true
        }
    }

    stages {
        stage('Validate') {
            steps {
                script {
                    packerValidation(
                        packerFile = 'nexus.pkr.hcl',
                        projectDir = 'nexus'
                    )
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    packerBuild(
                        packerFile = 'nexus.pkr.hcl',
                        projectDir = 'nexus'
                    )
                }
            }
        }
    }
}
