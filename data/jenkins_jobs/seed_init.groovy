#!groovy

import javaposse.jobdsl.dsl.DslScriptLoader
import javaposse.jobdsl.plugin.JenkinsJobManagement

def seedJob = new File('/usr/share/jenkins/ref/init.groovy.d/seed_job.groovy')
def jenkinsJobManagement = new JenkinsJobManagement(System.out, [:], new File('.'))

new DslScriptLoader(jenkinsJobManagement).runScript(seedJob.text)