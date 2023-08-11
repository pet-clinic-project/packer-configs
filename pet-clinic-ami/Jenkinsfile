pipeline {

    agent{
    label 'agent-node'
    }

    parameters {
        string(name: 'VERSION', defaultValue: '1.0.0', description: 'Semantic version number')
    }

    environment {
        PATH = "$PATH:/opt/apache-maven-3.9.3/bin"
        directory = '/home/ubuntu/workspace/APPLICATION PIPELINES/app/petclinic/'
    }

    stages {

        stage('Clone') {
            steps {
                dir(directory){
                    git branch: 'main', url: 'https://github.com/techiescamp/java-spring-petclinic.git'
            }
            }
        }

        stage('Build') {
            steps {
                dir(directory){
                    sh """
                    sudo touch /var/log/petclinic.log
                    sudo chmod 777 /var/log/petclinic.log
                    ./mvnw package -Dmaven.test.skip=true
                    """
                }
            }
        }

        stage('Test') {
            steps {
                dir(directory){
                    sh(script: './mvnw --batch-mode -Dmaven.test.failure.ignore=true test')
            }
        }
    }

        stage('SonarQube Scan') {
            steps {
                dir(directory){
                    withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        mvn sonar:sonar \
                            -Dsonar.projectKey=sonarqube-petclinic_app \
                            -Dsonar.organization=sonarqube-petclinic\
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }
    }

        stage('Nexus-Artifact Upload'){
            steps{
                    withCredentials([usernamePassword(credentialsId: 'NEXUS-LOGIN', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    dir(directory + "target"){
                        sh '''
                            curl -v -u ${USERNAME}:${PASSWORD} \
                            --upload-file spring-petclinic-3.1.0-SNAPSHOT.jar \
                            http://54.244.121.108:8081/repository/maven-releases/petclinic-jarfile/org/springframework/boot/petclinic/3.0.7/petclinic-3.0.7.jar
                        '''
                }
            }
        }
        }

        stage('Validating'){
            steps{
                dir("/home/ubuntu/workspace/APPLICATION PIPELINES/app/"){
                sh 'packer validate vm.pkr.hcl'
                    }
                }
        }

        stage('Create AMI') {
            steps {
                dir("/home/ubuntu/workspace/APPLICATION PIPELINES/app/"){
                sh 'packer build -var "consul_server_ip=44.230.25.63" vm.pkr.hcl'
                }
            }
        }
    }
}

        