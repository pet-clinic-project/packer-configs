@Library('jenkins-shared-library@develop') _

pipeline {

    agent{
    label 'AGENT-01'
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