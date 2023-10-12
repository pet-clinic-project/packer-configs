@Library('jenkins-shared-library@develop') _

pipeline {
    agent {
        docker {
            image '814200988517.dkr.ecr.us-west-2.amazonaws.com/infra-images:packer-1.0.24'
            args '-v /var/run/docker.sock:/var/run/docker.sock --privileged -u root'
            reuseNode true
        }
    }

    parameters {
        choice(name: 'PACKER_FILE', choices: ['jenkins-controller.pkr.hcl', 'jenkins-agent.pkr.hcl'], description: 'Packer file name')
        choice(name: 'PROJECT_DIR', choices: ['jenkins-controller', 'jenkins-agent'], description: 'Project directory name')
    }

    stages {
        stage('Validate') {
            steps {
                script {
                    packer.validate(
                        packerFile = 'params.PACKER_FILE',
                        projectDir = 'params.PROJECT_DIR'
                    )
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    packer.build(
                        packerFile = 'params.PACKER_FILE',
                        projectDir = 'params.PROJECT_DIR'
                    )
                }
            }
        }
    }
}
