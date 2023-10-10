@Library('jenkins-shared-library@develop') _

pipeline {

    agent{
    label 'AGENT-01'
    }

    stages {
        stage('Validate') {
            steps {
                script {
                    packerValidation(
                        packerFile = 'pet-clinic.pkr.hcl',
                        projectDir = 'pet-clinic-ami'
                    )
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    packerBuild(
                        packerFile = 'pet-clinic.pkr.hcl',
                        projectDir = 'pet-clinic-ami'
                    )
                }
            }
        }
    }
}