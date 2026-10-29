@Library('jenkins-shared-library') _ 

def configMap = [
    project: "roboshop",
    component: "catalogue",
]


//  if branch is not main , run CI pipeline
if (! env.BRANCH_NAME == 'main') {
    nodejsEKSpipeline.groovy(configMap)
} 
else {
    echo "Please follow the CR process"
}