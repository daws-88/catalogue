pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }
    environment {
        COURSE = "jenkins"
        appVersion = ""
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
                sh 'npm install'
            }
        }
        stage('Build Image') {
            steps {
                script {
                    sh """
                        docker build -t catalogue:${appVersion} .
                        docker images
                    """
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
