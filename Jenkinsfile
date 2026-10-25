
pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }

    environment {
        COURSE = 'jenkins'
        APP_VERSION = ''
        ACC_ID = '843976228791'
        PROJECT = 'roboshop'
        COMPONENT = 'catalogue'
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
                    env.APP_VERSION = packageJson.version
                    echo "Application version: ${env.APP_VERSION}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'npm test'
            }
        }

        // stage('Dependabot Security Check') {
        //     environment {
        //         GITHUB_REPO = 'daws-88/catalogue'
        //         GITHUB_API = 'https://api.github.com'
        //     }

        //     steps {
        //         script {
        //             withCredentials([
        //                 string(
        //                     credentialsId: 'github-token',
        //                     variable: 'GITHUB_TOKEN'
        //                 )
        //             ]) {
        //                 def response = sh(
        //                     script: '''
        //                         curl -fsS \
        //                           -H "Accept: application/vnd.github+json" \
        //                           -H "Authorization: Bearer $GITHUB_TOKEN" \
        //                           -H "X-GitHub-Api-Version: 2022-11-28" \
        //                           "$GITHUB_API/repos/$GITHUB_REPO/dependabot/alerts?per_page=100"
        //                     ''',
        //                     returnStdout: true
        //                 ).trim()

        //                 // Parse JSON using the Pipeline Utility Steps plugin
        //                 def alerts = readJSON text: response

        //                 if (!(alerts instanceof List)) {
        //                     error('Invalid Dependabot API response')
        //                 }

        //                 def blockingAlerts = alerts.findAll { alert ->
        //                     alert.state == 'open' &&
        //                     alert.security_vulnerability?.severity in [
        //                         'high',
        //                         'critical'
        //                     ]
        //                 }

        //                 if (blockingAlerts) {
        //                     echo "Open High/Critical alerts: ${blockingAlerts.size()}"

        //                     blockingAlerts.each { alert ->
        //                         echo "Alert #${alert.number}: ${alert.security_vulnerability?.severity}"
        //                     }

        //                     error('Pipeline stopped: Open High/Critical vulnerabilities found')
        //                 }

        //                 echo 'No open High/Critical vulnerabilities found in the returned alerts.'
        //             }
        //         }
        //     }
        // }

        stage('Build Image') {
            steps {
                script {
                    withAWS(
                        credentials: 'aws-creds',
                        region: 'us-east-1'
                    ) {
                        sh """
                            aws ecr get-login-password --region us-east-1 |
                              docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com

                            docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${env.APP_VERSION} .

                            docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${env.APP_VERSION}
                        """
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Hello Deploying'
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
