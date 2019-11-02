#!groovy

import jenkins.model.Jenkins;

environments = ['staging', 'production']

environments.forEach { env ->
      def targetDir = "pcp-project-" + env
      folder(targetDir) {
            description('Jobs for ' + env + ' environment')
      }

      freeStyleJob(targetDir + "/pcp-crm") {
            steps {
                  shell "Hello world!"
            }
      }

      freeStyleJob(targetDir + "/pcp-accountant") {
            steps {
                  shell "Hello world!"
            }      
      }

      freeStyleJob(targetDir + "/pcp-printer") {
            steps {
                  shell "Hello world!"
            }      
      }

      freeStyleJob(targetDir + "/pcp-client") {
            steps {
                  shell "Hello world!"
            }      
      }
}



