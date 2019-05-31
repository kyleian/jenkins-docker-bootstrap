import jenkins.model.Jenkins

folder('Seed-Folder') {}

def projectsToBuild = [
    'My-Project':[ 
        // Add Project Parameters Here
    ]
]

projectsToBuild.each { project ->

    job("Seed-Folder/${project.key}") {
    
        parameters {
            stringParam('project-name', project.key, 'The name of the project..')
        }

        steps {
            environmentVariables {
                // Inherited from parameters
                env('project-name', '$project-name')
            }

            //managedScript('Jenkinsfile')
        }   
    }


    println("Completed bootstrapping job ${project.key}")     
}
