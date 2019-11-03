#!groovy

@Grab('org.yaml:snakeyaml:1.17')
import org.yaml.snakeyaml.Yaml
import jenkins.model.Jenkins;

class Server {
      private String name
      private String ip
      private String username
      private String remoteDirectory

      Server(String name, String ip, String username, String remoteDirectory) {
            this.name = name
            this.ip = ip
            this.username = username
            this.remoteDirectory = remoteDirectory
      }

      String getName() {
            return this.name
      }

      String getIp() {
            return this.ip
      }

      String getUsername() {
            return this.username
      }

      String getRemoteDirectory() {
            return this.remoteDirectory
      }

      String all() {
            return this.name + ' ' + this.ip + ' ' + this.username + ' ' + this.remoteDirectory
      }
}

def environments = ['staging', 'production']

def user = 'jenkins_pcp'
def remoteDirectory = '/opt/app'

def serversConfig = new Yaml().load(("/var/jenkins_home/resources/hosts.yml" as File).text)

def servers = [:]
serversConfig.each { key, val ->
      servers[key] = new Server(val.name, val.ip, val.username, val.remoteDirectory)
}

environments.forEach { env ->
      def targetDir = "pcp-project-" + env

      folder(targetDir) {
            description('Jobs for ' + env + ' environment')
      }

      freeStyleJob(targetDir + "/pcp-crm-" + env) {
            description('PCP CRM building pipeline job for ' + env + ' environment')

            properties {
                  githubProjectUrl('https://github.com/meksula/pcp-crm')
            }

            steps {
                  def server = servers[env + '_backend']
                  if(server != null) {
                        shell('/var/jenkins_home/resources/shell/send_over_ssh.sh ' + server.all())
                  }
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