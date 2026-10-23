pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }
    environment {
        COURSE = "jenkins"
        appVersion = ""
        ACC_ID = "843976228791"
        PROJECT = "roboshop"
        COMPONENT = "catalogue"
    }
    options {
        timeout(time: 10, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage('Read Version') {
            steps {
                script {
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "Application version: ${appVersion}"
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh """
                    npm install
                   """
            }
        }
        stage('unit test') {
            steps {
                sh """
                    npm test
                   """
            }
        }
         stage('sonar scan') {
            environment {
                 def scannerHome = tool 'Sonar-8.0'
            }
            steps {
                withSonarQubeEnv('SonarQube-Server') {                   
                    sh "${scannerHome}/bin/sonar-scanner"
            }
         }
       }
        stage('Build Image') {
            steps {
                script {
                   withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                        docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                        docker images
                        docker push  ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}                   
                       """
                   }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo "Hello Deploying"
            }
        }
    }

    post {
        always {
            echo 'I will always say Hello'
            cleanWs()
        }
        success {
            echo 'Run if pipeline success'
        }
        failure {
            echo 'Run if pipeline failure'
        }
        aborted {
            echo 'Pipeline is aborted'
        }
    }
}
