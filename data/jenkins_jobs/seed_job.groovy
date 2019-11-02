#!groovy

import jenkins.model.Jenkins;

environments = ['staging', 'production']
environments.forEach { env ->
      def targetDir = "pcp-project-" + env
      
      folder(targetDir) {
            description('Jobs for ' + env + ' environment')
      }

      freeStyleJob(targetDir + "/pcp-crm-" + env) {
            steps {
                  shell "Hello world!"
            }
      }

      freeStyleJob(targetDir + "/pcp-accountant-" + env) {
            steps {
                  shell "Hello world!"
            }      
      }

      freeStyleJob(targetDir + "/pcp-printer-" + env) {
            steps {
                  shell "Hello world!"
            }      
      }

      freeStyleJob(targetDir + "/pcp-client-" + env) {
            steps {
                  shell "Hello world!"
            }      
      }
}