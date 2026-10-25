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
    //      stage('sonar scan') {
    //         environment {
    //              def scannerHome = tool 'sonar-8.0'
    //         }
    //         steps {
    //             withSonarQubeEnv('sonar-scanner') {                   
    //                 sh "${scannerHome}/bin/sonar-scanner"
    //         }
    //      }
    //    }
        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 1, unit: 'HOURS') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }
        stage('Dependabot Security Check') {
            environment {
                GITHUB_REPO = 'daws-88/catalogue'
                GITHUB_API = 'https://api.github.com/repos/daws-88/catalogue/dependabot/alerts'
            }
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')
                    ]) {
                        def response = sh(
                            script: '''
                                curl -s \
                                -H "Accept: application/vnd.github+json" \
                                -H "Authorization: Bearer $GITHUB_TOKEN" \
                                "$GITHUB_API/repos/$GITHUB_REPO/dependabot/alerts
                            ''',
                            returnStdout: true
                        ).trim()
                        def alerts = new groovy.json.JsonSlurperClassic()
                            .parseText(response)
                        if (!(alerts instanceof List)) {
                            error('Invalid Dependabot API response')
                        }
                        def blockingAlerts = alerts.findAll { alert ->
                            alert.state == 'open' &&
                            alert.security_vulnerability?.severity in ['high', 'critical']
                        }
                        if (blockingAlerts) {
                            echo "Open High/Critical alerts: ${blockingAlerts.size()}"
                            blockingAlerts.each { alert ->
                                echo "Alert #${alert.number}: ${alert.security_vulnerability?.severity}"
                            }
                            error('Pipeline stopped: Open High/Critical vulnerabilities found')
                        }
                        echo 'No open High/Critical vulnerabilities found. Proceeding.'
                    }
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
