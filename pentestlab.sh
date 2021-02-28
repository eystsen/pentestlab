#!/bin/bash


ETC_HOSTS=/etc/hosts

#########################
# The command line help #
#########################
display_help() {
    echo "Local PentestLab Management Script (Docker based)"
    echo
    echo "Usage: $0 {list|status|info|start|startpublic|stop} [projectname]" >&2
    echo
    echo " This scripts uses docker and hosts alias to make web apps available on localhost"
    echo 
    echo " Ex."
    echo " $0 list"
    echo " 	List all available projects"
    echo " $0 status"
    echo "	Show status for all projects"
    echo " $0 start bwapp"
    echo " 	Start project and make it available on localhost" 
    echo " $0 startpublic bwapp"
    echo " 	Start project and make it publicly available (to anyone with network connectivity to the machine)" 
    echo " $0 info bwapp"
    echo " 	Show information about bwapp proejct"
    echo
    echo " Dockerfiles from:"
    echo "  DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)"
    echo "  Mutillidae II          - OWASP Project (citizenstig/nowasp)"
    echo "  bWapp                  - Rory McCune (raesene/bwapp)"
    echo "  Webgoat(s)             - OWASP Project"
    echo "  Juice Shop             - OWASP Project (bkimminich/juice-shop)"
#    echo "  Security Sheperd       - OWASP Project (ismisepaul/securityshepherd)"
    echo "  Vulnerable Wordpress   - Custom made from github.com/wpscanteam/VulnerableWordpress"
    echo "  Security Ninjas        - OpenDNS Security Ninjas AppSec Training"
    echo "  Altoro Mutual          - Custom made from github.com/hclproducts/altoroj"
    echo "  Vulnerable GraphQL API - Carve Systems LLC (carvesystems/vulnerable-graphql-api)"

    exit 1
}


############################################
# Check if docker is installed and running #
############################################
if ! [ -x "$(command -v docker)" ]; then
  echo 
  echo "Docker was not found. Please install docker before running this script."
  echo "For kali linux you can install docker with the following command:"
  echo "  apt install docker.io"
  exit
fi

if sudo service docker status | grep inactive > /dev/null
then 
	echo "Docker is not running."
	echo -n "Do you want to start docker now (y/n)?"
	read answer
	if echo "$answer" | grep -iq "^y"; then
		sudo service docker start
	else
		echo "Not starting. Script will not be able to run applications."
	fi
fi


#########################
# List all pentest apps #
#########################
list() {
    echo "Available pentest applications" >&2
    echo "  bwapp 		- bWAPP PHP/MySQL based from itsecgames.com"
    echo "  webgoat7		- OWASP WebGoat 7.1"
    echo "  webgoat8		- OWASP WebGoat 8.0"
    echo "  webgoat81		- OWASP WebGoat 8.1"
    echo "  dvwa     		- Damn Vulnerable Web Application"
    echo "  mutillidae		- OWASP Mutillidae II"
    echo "  juiceshop		- OWASP Juice Shop"
    echo "  vulnerablewordpress	- WPScan Vulnerable Wordpress"
    echo "  securityninjas	- OpenDNS Security Ninjas"
    echo "  altoro		- Altoro Mutual Vulnerable Bank"
    echo "  graphql		- Vulnerable GraphQL API"

#    echo "  securitysheperd	- OWASP Security Sheperd"
    echo
    exit 1

}

#########################
# Info dispatch         #
#########################
info () {
  case "$1" in 
    bwapp)
      project_info_bwapp
      ;;
    webgoat7)
      project_info_webgoat7
      ;;
    webgoat8)
      project_info_webgoat8      
      ;;
    webgoat81)
      project_info_webgoat8  
      ;;
    dvwa)
      project_info_dvwa 
      ;;
    mutillidae)
      project_info_mutillidae
    ;;
    juiceshop)
      project_info_juiceshop
    ;;
    vulnerablewordpress)
      project_info_vulnerablewordpress
    ;;
    securityninjas)
      project_info_securityninjas
    ;;
    altoro)
      project_info_altoro
    ;;
    graphql)
      project_info_graphql
    ;;
    *) 
      echo "Unknown project name"
      list
      ;;
  esac  
}



#########################
# hosts file util       #
#########################  # Based on https://gist.github.com/irazasyed/a7b0a079e7727a4315b9
function removehost() {
    if [ -n "$(grep $1 /etc/hosts)" ]
    then
        echo "Removing $1 from $ETC_HOSTS";
        sudo sed -i".bak" "/$1/d" $ETC_HOSTS
    else
        echo "$1 was not found in your $ETC_HOSTS";
    fi
}

function addhost() { # ex.   127.5.0.1	bwapp
    HOSTS_LINE="$1\t$2"
    if [ -n "$(grep $2 /etc/hosts)" ]
        then
            echo "$2 already exists in /etc/hosts"
        else
            echo "Adding $2 to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $2 /etc/hosts)" ]
                then
                    echo -e "$HOSTS_LINE was added succesfully to /etc/hosts";
                else
                    echo "Failed to Add $2, Try again!";
            fi
    fi
}


#########################
# PROJECT INFO & STARTUP#
#########################
project_info_bwapp () 
{
echo "http://www.itsecgames.com"
}

project_startinfo_bwapp () 
{
  echo "Default username/password:  bee/bug"  

  if [ -z $1 ]
  then
    echo "Run install first to use bWapp at http://bwapp/install.php"
  else
    echo "Run install first to use bWapp at http://$1/install.php"
  fi
}

project_info_webgoat7 () 
{
echo "https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project"
}

project_startinfo_webgoat7 () 
{
  echo "WebGoat 7.0 now runnung at http://webgoat7/WebGoat or http://127.6.0.1/WebGoat"
}

project_info_webgoat8 () 
{
echo "  https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project"
}

project_startinfo_webgoat8 () 
{
  echo "WebGoat 8.0 now runnung at http://webgoat8/WebGoat or http://127.7.0.1/WebGoat"
}

project_startinfo_webgoat81 () 
{
  echo "WebGoat 8.1 now runnung at http://webgoat81/WebGoat or http://127.17.0.1/WebGoat"
  echo "WebWolf is not mapped yet, so only challenges not using WebWolf can be completed"
}


project_info_dvwa () 
{
echo "http://www.itsecgames.com"
}

project_startinfo_dvwa () 
{
  echo "Default username/password:   admin/password"
  echo "Remember to click on the CREATE DATABASE Button before you start"
}

project_info_mutillidae () 
{
echo "https://www.owasp.org/index.php/OWASP_Mutillidae_2_Project"
}

project_startinfo_mutillidae () 
{
  echo "Remember to click on the create database link before you start"
}

project_info_juiceshop () 
{
echo "https://owasp-juice.shop"
}

project_startinfo_juiceshop () 
{
  echo "OWASP Juice Shop now running"
}

project_info_securitysheperd () 
{
echo "https://www.owasp.org/index.php/OWASP_Security_Shepherd"
}

project_startinfo_securitysheperd () 
{
  echo "OWASP Security Sheperd running"
}

project_info_vulnerablewordpress () 
{
echo "https://github.com/wpscanteam/VulnerableWordpress"
}

project_startinfo_vulnerablewordpress () 
{
  echo "WPScan Vulnerable Wordpress site now running"
}

project_info_securityninjas () 
{
echo "https://github.com/opendns/Security_Ninjas_AppSec_Training"
}

project_startinfo_securityninjas ()
{
  echo "Open DNS Security Ninjas site now running"
}
project_info_altoro () 
{
echo "https://github.com/opendns/Security_Ninjas_AppSec_Training"
}

project_startinfo_altoro ()
{
  echo "Sign in with username jsmith and password demo1234 to initialize database." 
  echo "Second known credential is admin/admin"
}

project_info_graphql () 
{
echo "https://carvesystems.com/news/the-5-most-common-graphql-security-vulnerabilities/"
}

project_startinfo_graphql ()
{
  echo "Vulnerable GraphQL now mapped to port 80 (not 3000 as documentation states)." 
  echo "Have a look at this post for more information on this API: https://carvesystems.com/news/the-5-most-common-graphql-security-vulnerabilities/"
}




#########################
# Common start          #
#########################
project_start ()
{
  fullname=$1		# ex. WebGoat 7.1
  projectname=$2     	# ex. webgoat7
  dockername=$3  	# ex. raesene/bwapp
  ip=$4   		# ex. 127.5.0.1
  port=$5		# ex. 80
  port2=$6		# optional override port (if app doesn't support portmapping)
  
  echo "Starting $fullname"
  addhost "$ip" "$projectname"

  if [ "$(sudo docker ps -aq -f name=^/$projectname$)" ]; 
  then
    echo "Running command: docker start $projectname"
    sudo docker start $projectname
  else
    if [ -n "${6+set}" ]; then
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername
    else echo "not set";
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port $dockername
    fi
  fi
  echo "DONE!"
  echo
  echo "Docker mapped to http://$projectname or http://$ip"
  echo
}

project_startpublic ()
{
  fullname=$1			# ex. WebGoat 7.1
  projectname=$2public     	# ex. webgoat7
  dockername=$3  		# ex. raesene/bwapp
  internalport=$4               # ex. 8080
  publicip=$5                   # ex. 192.168.0.105
  port=$6			# ex. 80
  
  echo "Starting $fullname for public access"

  if [ "$(sudo docker ps -aq -f name=^/$projectname$)" ]; 
  then
    echo "Running command: docker start $projectname"
    sudo docker start $projectname
  else
    echo "Running command: docker run --name $projectname -d -p $publicip:$port:$internalport $dockername"
    sudo docker run --name $projectname -d -p $publicip:$port:$internalport $dockername
  fi
  
  echo "DONE!"
  echo
  if [ $port -eq 80 ]
  then
    echo "$fullname now available on http://$publicip"
  else
    echo "$fullname now available on http://$publicip:$port"
  fi  
  echo
}


#########################
# Common stop           #
#########################
project_stop ()
{
  fullname=$1	# ex. WebGoat 7.1
  projectname=$2     # ex. webgoat7

  if [ "$(sudo docker ps -q -f name=^/$projectname$)" ]; 
  then
    echo "Stopping... $fullname"
    echo "Running command: docker stop $projectname"
    sudo docker stop $projectname
    removehost "$projectname"
  fi

  projectname=${projectname}public
  if [ "$(sudo docker ps -q -f name=^/$projectname$)" ]; 
  then
    echo "Stopping... $fullname"
    echo "Running command: docker stop $projectname"
    sudo docker stop $projectname
  fi
}



project_running()
{
  projectname=$1
  shortname=$2
  url=$3
  running=0

  if [ "$(sudo docker ps -q -f name=^/${shortname}$)" ]; then
    echo "$projectname		running at $url (localhost)"
    running=1
  fi
  if [ "$(sudo docker ps -q -f name=^/${shortname}public$)" ]; then
    echo "$projectname		running (public)"
    running=1
  fi  
  if [ $running -eq 0 ];
  then
    echo "$projectname		not running"
  fi 
}

project_status()
{
  project_running "bWapp                        " "bwapp" "http://bwapp"
  project_running "WebGoat 7.1                  " "webgoat7" "http://webgoat7/WebGoat"
  project_running "WebGoat 8.0                  " "webgoat8" "http://webgoat8/WebGoat"
  project_running "WebGoat 8.1                  " "webgoat81" "http://webgoat81/WebGoat"
  project_running "DVWA                         " "dvwa" "http://dvwa"
  project_running "Mutillidae II                " "mutillidae" "http://mutillidae"
  project_running "OWASP Juice Shop             " "juiceshop" "http://juiceshop"
  project_running "WPScan Vulnerable Wordpress  " "vulnerablewordpress" "http://vulnerablewordpress"
  project_running "OpenDNS Security Ninjas      " "securityninjas" "http://securityninjas"
  project_running "Altoro Mutual                " "altoro" "http://altoro"
  project_running "Vulnerable GraphQL API       " "graphql" "http://graphql"
 
#  if [ "$(sudo docker ps -q -f name=securitysheperd)" ]; then
#    echo "OWASP Security Sheperd		running at http://securitysheperd"
#  else 
#    echo "OWASP Security Sheperd		not running"  
#  fi
}


project_start_dispatch()
{
  case "$1" in
    bwapp)
      project_start "bWAPP" "bwapp" "raesene/bwapp" "127.5.0.1" "80"
      project_startinfo_bwapp
    ;;
    webgoat7)
      project_start "WebGoat 7.1" "webgoat7" "webgoat/webgoat-7.1" "127.6.0.1" "8080"
      project_startinfo_webgoat7
    ;;
    webgoat8)
      project_start "WebGoat 8.0" "webgoat8" "webgoat/webgoat-8.0" "127.7.0.1" "8080"
      project_startinfo_webgoat8
    ;;    
    webgoat81)
      project_start "WebGoat 8.1" "webgoat81" "webgoat/goatandwolf" "127.17.0.1" "8080"
      project_startinfo_webgoat81
    ;;    
    dvwa)
      project_start "Damn Vulnerable Web Appliaction" "dvwa" "vulnerables/web-dvwa" "127.8.0.1" "80"
      project_startinfo_dvwa
    ;;    
    mutillidae)
      project_start "Mutillidae II" "mutillidae" "citizenstig/nowasp" "127.9.0.1" "80"
      project_startinfo_mutillidae
    ;;
    juiceshop)
      project_start "OWASP Juice Shop" "juiceshop" "bkimminich/juice-shop" "127.10.0.1" "3000"
      project_startinfo_juiceshop
    ;;
    securitysheperd)
      project_start "OWASP Security Shepard" "securitysheperd" "ismisepaul/securityshepherd" "127.11.0.1" "80"
      project_startinfo_securitysheperd
    ;;
    vulnerablewordpress)
      project_start "WPScan Vulnerable Wordpress" "vulnerablewordpress" "eystsen/vulnerablewordpress" "127.12.0.1" "80" "3306"
      project_startinfo_vulnerablewordpress
    ;;
    securityninjas)    
      project_start "Open DNS Security Ninjas" "securityninjas" "opendns/security-ninjas" "127.13.0.1" "80"
      project_startinfo_securityninjas
    ;;
    altoro)    
      project_start "Altoro Mutual" "altoro" "eystsen/altoro" "127.14.0.1" "8080"
      project_startinfo_altoro
    ;;
    graphql)    
      project_start "Vulnerable GraphQL API" "graphql" "carvesystems/vulnerable-graphql-api" "127.15.0.1" "3000"
      project_startinfo_graphql
    ;;
    *)
    echo "ERROR: Project start dispatch doesn't recognize the project name $1" 
    ;;
  esac  
}

project_startpublic_dispatch()
{
  publicip=$2
  port=$3
  
  case "$1" in
    bwapp)
      project_startpublic "bWAPP" "bwapp" "raesene/bwapp" "80" $publicip $port
      project_startinfo_bwapp $publicip
    ;;
    webgoat7)
      project_startpublic "WebGoat 7.1" "webgoat7" "webgoat/webgoat-7.1" "8080" $publicip $port
      project_startinfo_webgoat7 $publicip
    ;;
    webgoat8)
      project_startpublic "WebGoat 8.0" "webgoat8" "webgoat/webgoat-8.0" "8080" $publicip $port
      project_startinfo_webgoat8 $publicip
    ;;    
    webgoat81)
      project_startpublic "WebGoat 8.1" "webgoat81" "webgoat/goatandwolf" "8080" $publicip $port
      project_startinfo_webgoat8 $publicip
    ;;    
    dvwa)
      project_startpublic "Damn Vulnerable Web Appliaction" "dvwa" "vulnerables/web-dvwa" "80" $publicip $port
      project_startinfo_dvwa $publicip
    ;;    
    mutillidae)
      project_startpublic "Mutillidae II" "mutillidae" "citizenstig/nowasp" "80" $publicip $port
      project_startinfo_mutillidae $publicip
    ;;
    juiceshop)
      project_startpublic "OWASP Juice Shop" "juiceshop" "bkimminich/juice-shop" "3000" $publicip $port
      project_startinfo_juiceshop $publicip
    ;;
    securitysheperd)
      project_startpublic "OWASP Security Shepard" "securitysheperd" "ismisepaul/securityshepherd" "80" $publicip $port
      project_startinfo_securitysheperd $publicip
    ;;
    vulnerablewordpress)
      project_startpublic "WPScan Vulnerable Wordpress" "vulnerablewordpress" "eystsen/vulnerablewordpress" "3306" $publicip $port
      project_startinfo_vulnerablewordpress $publicip
    ;;
    securityninjas)    
      project_startpublic "Open DNS Security Ninjas" "securityninjas" "opendns/security-ninjas" "80" $publicip $port
      project_startinfo_securityninjas $publicip
    ;;
    altoro)    
      project_startpublic "Altoro Mutual" "altoro" "eystsen/altoro" "8080" $publicip $port
      project_startinfo_altoro $publicip
    ;;
    graphql)    
      project_startpublic "Vulnerable GraphQL API" "graphql" "carvesystems/vulnerable-graphql-api" "3000" $publicip $port
      project_startinfo_altoro $publicip
    ;;
    *)
    echo "ERROR: Project public dispatch doesn't recognize the project name $1" 
    ;;
  esac  
}


project_stop_dispatch()
{
  case "$1" in
    bwapp)
      project_stop "bWAPP" "bwapp"
    ;;
    webgoat7)
      project_stop "WebGoat 7.1" "webgoat7"
    ;;
    webgoat8)
      project_stop "WebGoat 8.0" "webgoat8"
    ;;
    webgoat81)
      project_stop "WebGoat 8.1" "webgoat81"
    ;;
    dvwa)
      project_stop "Damn Vulnerable Web Appliaction" "dvwa"
    ;;
    mutillidae)
      project_stop "Mutillidae II" "mutillidae"
    ;;
    juiceshop)
      project_stop "OWASP Juice Shop" "juiceshop"
    ;;
    securitysheperd)
      project_stop "OWASP Security Sheperd" "securitysheperd"
    ;;
    vulnerablewordpress)
      project_stop "WPScan Vulnerable Wordpress" "vulnerablewordpress"
    ;;
    securityninjas)
      project_stop "Open DNS Security Ninjas" "securityninjas"
    ;;
    altoro)
      project_stop "Altoro Mutual" "altoro"
    ;;
    graphql)
      project_stop "Vulnerable GraphQL API" "graphql"
    ;;
    *)
    echo "ERROR: Project stop dispatch doesn't recognize the project name $1" 
    ;;
  esac  
}


#########################
# Main switch case      #
#########################

  case "$1" in
    start)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi
      project_start_dispatch $2
      ;;
    startpublic)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi

      if [ -z "$4" ]
      then
        port=80
      else
        port=$4
      fi


      if [ "$3" ]
      then
        publicip=$3
      else
      	publicip=`hostname -I | cut -d" " -f1`
    
	echo "Continue using local IP address $publicip?"
        select yn in "Yes" "No"; do
          case $yn in
            Yes )  
              break;;
            No ) 
              echo "Specify the correct IP address.";  
              echo " ex."; 
              echo "   $0 startpublic bwapp 192.168.0.105"; 
              exit;;
          esac
        done
      fi

      listen="$publicip:$port"
      if [ "$(netstat -ln4 | grep -w $listen )" ]
      then
        echo "$publicip already listening on port $port"
        echo "Free up the port or select a different port to bind $2"
        exit
      fi

      project_startpublic_dispatch $2 $publicip $port
      echo "WARNING! Only do this in trusted lab environment. WARNING!"
      echo "WARNING! Anyone with nettwork access can now pwn this machine! WARNING!" 
      ;;
    stop)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi
      project_stop_dispatch $2
      ;;
    list)
      list # call list ()
      ;;
    status)
      project_status # call project_status ()
      ;;
    info)
      if [ -z "$2" ]
      then
    	echo "ERROR: Option start needs project name in lowercase"
        echo 
        list # call list ()
        break
      fi
      info $2
      ;;
    *)
      display_help
      ;;
  esac  
 