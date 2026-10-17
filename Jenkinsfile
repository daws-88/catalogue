pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }
    environment {
        COURSE ="jenkins"
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
                   appVersion = packageJson.Version
            }
            
        }
        }
        stage('install dependencies') {
            steps {
                script {
                   sh """
                     npm install
                     """
        }
      }
   }
       stage('build image') {
            steps {
                steps {
                script {
                   sh """
                     docker build -t catalogue:${appVersion} .
                     docker images
                    """
        }
        }
      }
        stage('Depoly') {
            // input {
            //     message "Should we continue?"
            //     ok "Yes, we should."
            //     submitter "alice,bob"
            //     parameters {
            //         string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
            //     }
            // }
            // when {
            //     expression {
            //          "$params.DEPLOY == true"
            //                }
            //     }

            steps {
                echo "Hello Depolying"         
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
            echo 'pipeline is aborted'
        }
    }
}
}
}