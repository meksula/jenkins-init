#!groovy

/**
* This script adds deployment target hosts to Jenkins instance.
* Old configured servers will not override, but new configuration rows will added
* */

@Grab('org.yaml:snakeyaml:1.17')
import org.yaml.snakeyaml.Yaml
import jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin
import jenkins.plugins.publish_over_ssh.BapSshHostConfiguration

def hosts = new Yaml().load(("/var/jenkins_home/resources/hosts.yml" as File).text)
def descriptor = Jenkins.instance.getDescriptorByType(BapSshPublisherPlugin.Descriptor.class)

hosts.each{ key, val ->  
  	descriptor.addHostConfiguration(
        new BapSshHostConfiguration(
  			val.name,
  			val.ip,
  			val.username,
  			 null,
  			val.remoteDirectory,
  			 22,
  			 300000,
  			 true,
  			'/root/.ssh/id_rsa',
  			'',
  			 false
	    )
    )
}
