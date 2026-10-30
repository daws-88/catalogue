@Library('jenkins-shared-library') _

def configmap = [
    project  : 'roboshop',
    component: 'catalogue'
]

if (env.BRANCH_NAME != 'main') {
    nodejsEKSpipeline(configmap)
} else {
    echo 'Please follow the CR process'
}
