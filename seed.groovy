import jenkins.model.*;
import hudson.model.FreeStyleProject;
import hudson.tasks.Shell;
import javaposse.jobdsl.plugin.*;
import javapossee.jobdsl.*;

// Create project object
project = Jenkins.instance.createProject(FreeStyleProject, "bootstrap")

// Point to init.groovy.d for workspace, since setTargets doesn't like absolute paths
project.setCustomWorkspace("/usr/share/jenkins/ref/init.groovy.d/")

// Wipe out anything before creating the build list
project.getBuildersList().clear()

// Set up DSL build Info
executeDslScripts = new ExecuteDslScripts()
executeDslScripts.setTargets("job-dsl/*.groovy")
executeDslScripts.setRemovedJobAction(RemovedJobAction.DELETE)
executeDslScripts.setRemovedViewAction(RemovedViewAction.DELETE)
executeDslScripts.setLookupStrategy(LookupStrategy.JENKINS_ROOT)
executeDslScripts.setAdditionalClasspath("src/main/groovy")

// Add DSL scripts to build list
project.getBuildersList().add(executeDslScripts)

// Save project
project.save()

// Run bootstrap after being created
// def bootstrapFullName = Jenkins.instance.getItemByFullName('bootstrap');
// queue('bootstrap')

