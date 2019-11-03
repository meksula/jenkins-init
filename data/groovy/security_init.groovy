#!groovy
 
@Grab('org.yaml:snakeyaml:1.17')
import org.yaml.snakeyaml.Yaml
import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()
 
def users = new Yaml().load(("/var/jenkins_home/resources/users.yml" as File).text)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
users.each { key, val ->
      hudsonRealm.createAccount(val.username, val.password)
      println 'Account created for user: ' + val.username
}
instance.setSecurityRealm(hudsonRealm)

instance.setAuthorizationStrategy(new FullControlOnceLoggedInAuthorizationStrategy())
instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
instance.getDescriptor("jenkins.CLI").get().setEnabled(false)

instance.injector.getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false);

instance.setSlaveAgentPort(-1);

instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
HashSet<String> newProtocols = new HashSet<>(instance.getAgentProtocols());
newProtocols.removeAll(Arrays.asList("JNLP3-connect", "JNLP2-connect", "JNLP-connect", "CLI-connect"));
instance.setAgentProtocols(newProtocols);

instance.save()
