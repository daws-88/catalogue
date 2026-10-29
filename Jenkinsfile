@Library('jenkins-shared-library') _

def configMap = [
    project  : 'roboshop',
    component: 'catalogue'
]

if (env.BRANCH_NAME != 'main') {
    nodejsEKSpipeline(configMap)
} else {
    echo 'Please follow the CR process'
}
