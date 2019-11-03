# jenkins-init
Jenkins environment starting by one command.

This projects helps to automate build of Jenkins testing environment. 
In simple way, by run one script you can install whole Jenkins environment required components.

#### How it works?
1. Installation of Virtualbox, Vagrant and additional required plugins (VBguest etc.)
2. Instantiate of Centos 7 Virtual Machine 
3. Build Jenkins Docker Container
4. Execute bunch of prepared before groovy scripts in order to prepare Jenkins configuration
5. Make Seed Job for our children jobs
6. Jenkins is ready and wait for you by default here: http://89.168.33.10:8080/


#### How it works?
```
$ ./build.sh
```

Thats all! This is really simple :)
