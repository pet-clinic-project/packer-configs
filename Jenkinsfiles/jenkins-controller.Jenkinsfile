@Library('jenkins-shared-library@develop') _

pipeline {
    agent {
    label 'AGENT-01'
    }

    stages {
        stage('Validate') {
            steps {
                script {
                    packerValidation(
                        packerFile = 'jenkins-controller.pkr.hcl',
                        projectDir = 'jenkins-controller'
                    )
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    packerBuild(
                        packerFile = 'jenkins-controller.pkr.hcl',
                        projectDir = 'jenkins-controller'
                    )
                }
            }
        }
    }
}
