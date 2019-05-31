FROM jenkins/jenkins:lts-alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy seed job
COPY *.groovy /usr/share/jenkins/ref/init.groovy.d/

# Copy job generation scripts
COPY job-dsl/ /usr/share/jenkins/ref/init.groovy.d/job-dsl/