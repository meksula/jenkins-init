#!groovy

import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope

def githubSshKey = new BasicSSHUserPrivateKey(
      CredentialsScope.GLOBAL, 
      'github_ssh', 
      'meksula', 
      new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(new File('/root/.ssh/id_rsa').text),
      '',
      ''
)

SystemCredentialsProvider.getInstance().getCredentials().add(githubSshKey)