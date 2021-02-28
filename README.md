# Local PentestLab Management Script

Bash script to manage web apps using docker and hosts aliases.  
Made for Kali linux, but should work fine with pretty much any linux distro.

### Current available webapps

* bWAPP
* WebGoat 7.1
* WebGoat 8.0
* Damn Vulnerable Web App
* Mutillidae II
* OWASP Juice Shop
* WPScan Vulnerable Wordpress
* OpenDNS Security Ninjas
* Altoro Mutual
* Vulnerable GraphQL API


### Get started 

Using any of these apps can be done in 3 quick and simple steps.

#### 1) Clone the repo
Clone this repo, or download it any way you prefer
```
git clone https://github.com/eystsen/pentestlab.git
cd pentestlab
```

#### 2) Install docker
The provided docker install script is no longer needed. 
On Kali 2020 you can install docker using apt, like this: 
```
sudo apt install docker.io
```

For any other distro, use the prefered way to install docker.


#### 3) Start an app on localhost
Now you can start and stop one or more of these apps on your system.
As an example, to start bWAPP just run this command
```
./pentestlab.sh start bwapp
```
This will download the docker, add bwapp to hosts file and run the docker
mapped to one of the localhost IPs.
That means you can just point your browser to http://bwapp and it will be up
and running.


#### 4) Start an app and expose it from machine
Use the startpublic command to bind the app to your IP
```
./pentestlab.sh startpublic bwapp
```
If you have multiple interfaces and/or IPs, **or** you need to expose the app on a different port specify it like this
```
./pentestlab.sh startpublic bwapp 192.168.1.105 8080
```
IP needs to be an IP on the machine and port in this example is 8080

You can only have one app exposed on any given port. If you need to expose more than one app, you need to use different ports.


#### 5) Stopp any app
To stop any app use the stop command
```
./pentestlab.sh stop bwapp
```


#### Print a complete list of available projects use the list command
```
./pentestlab.sh list 
```

#### Running just the script will print help info
```
./pentestlabs.sh 
```


### Usage
```
Usage: ./pentestlab.sh {list|status|info|start|startpublic|stop} [projectname]

 This scripts uses docker and hosts alias to make web apps available on localhost"

Ex.
./pentestlab.sh list
   List all available projects  

./pentestlab.sh status
   Show status for all projects  

./pentestlab.sh start bwapp
   Start docker container with bwapp and make it available on localhost  

./pentestlab.sh startpublic bwapp
   Start docker container with bwapp and make it available on machine IP 

./pentestlab.sh stop bwapp
   Stop docker container

./pentestlab.sh info bwapp
   Show information about bwapp project
```

 ### Dockerfiles from
 DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)  
 Mutillidae II          - OWASP Project (citizenstig/nowasp)  
 bWapp                  - Rory McCune (raesene/bwapp)  
 Webgoat(s)             - OWASP Project  
 Juice Shop             - OWASP Project (bkimminich/juice-shop)  
 Vulnerable Wordpress   - github.com/wpscanteam/VulnerableWordpress  
 Security Ninjas        - OpenDNS Security Ninjas  
 Altoro Mutual          - github.com/hclproducts/altoroj  
 Vulnerable GraphQL API - Carve Systems LLC (carvesystems/vulnerable-graphql-api)

github references means the docker is custom created and hosted in dockerhub.


## Troubleshoot / FAQ

### I can't connect to the application I just stared, what is wrong?
- Make sure you are using HTTP not HTTPS
- Try using the IP address instead of the name (to see if the issue is with host file or docker)
- If you are still not able to connect then follow the steps below to create a ticket

### I still cannot make it work, how do I create an issue to get help?
Do these steps and record ouput (image, copy paste from screen, whatever works for you)
- Stop the application first (to clean up some configuration that are done during start)
- Start the application again 
- Run this command to get information about running dockers
```
sudo docker ps
```
- Try to access the application using the IP address
