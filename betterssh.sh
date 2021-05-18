#!/bin/bash
##Script Built & Maintained by Github.com/Volarken
##Contact for inquiries or issues @ Github@Webhost.sh##
##Release 1.0##
func_logEvent () {
TIME0=$(date)
LOGFILE="/usr/bin/betterssh/log.txt"
sudo /bin/cat <<-EOM >>$LOGFILE
        $LogInput $TIME0
			EOM
}
func_autoUpdate(){
version=$(curl -s https://raw.githubusercontent.com/Volarken/betterssh/main/version.txt)
versionCurrent="$(cat /usr/bin/betterssh/version.txt)"
clear
if [ "$versionCurrent" = "$version" ]; then
LogInput="Script up to date, last update check ran on "
func_logEvent
else
LogInput="Script is outdated, running update protocols on "
func_logEvent
sudo mkdir -p /usr/bin/betterssh
sudo -s curl https://raw.githubusercontent.com/Volarken/betterssh/main/version.txt -o /usr/bin/betterssh/version.txt > /dev/null
sudo -s curl -L https://raw.githubusercontent.com/Volarken/betterssh/main/betterssh.sh -o "$0" > /dev/null
clear
sudo bash "$0"
fi
}
func_requiredRepos () { 
if [ $(dpkg-query -W -f='${Status}' shc 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  LogInput="One or more required repositories are not installed, will aquire now at "
  func_logEvent
  echo You are missing required files, we will aquire them now. This may take a while. 
  read -p 'Press enter to continue.'
  sudo apt-get install npm nodejs
  sudo apt-get install shc
  sudo apt-get install sshpass
  ln -s /usr/bin/nodejs /usr/bin/node
  npm install -g bash-obfuscate
  sudo apt-get install shc
  sudo apt-get update
fi
if [ $(dpkg-query -W -f='${Status}' npm nodejs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  LogInput="One or more required repositories are not installed, will aquire now at "
  func_logEvent
  echo You are missing required files, we will aquire them now. This may take a while. 
  read -p 'Press enter to continue.'
  sudo apt-get install npm nodejs
  sudo apt-get install shc
  sudo apt-get install sshpass
  ln -s /usr/bin/nodejs /usr/bin/node
  npm install -g bash-obfuscate
  sudo apt-get install shc
fi
clear
if [ $(dpkg-query -W -f='${Status}' sshpass 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  LogInput="One or more required repositories are not installed, will aquire now at "
  func_logEvent
  echo You are missing required files, we will aquire them now. This may take a while. 
  read -p 'Press enter to continue.'
  sudo apt-get install npm nodejs
  sudo apt-get install shc
  sudo apt-get install sshpass
  ln -s /usr/bin/nodejs /usr/bin/node
  npm install -g bash-obfuscate
  sudo apt-get install shc
fi
clear
}

##Main Menu Functions##
mmOp1 () {
    #Server Information#
    PORT=22
    USR=root
    echo Server Name? 
    echo '(this is the name that you will type in order to connect, So make it memorable.)'
    read -p '' -e NAME
    echo Server IP? 
    read -p '' -e HOST
    echo Server Password?
    read -p '' -e PASS
      echo $PASS >> 1.txt
    PASS=$(sed -e "s/'/'\\\\''/g; 1s/^/'/; \$s/\$/'/" 1.txt)
    rm 1.txt

    echo Would you like to set a custom port? [DEFAULT=22]
    read -p 'Y/N ' -e PORTQUESTION
     if [[ "$PORTQUESTION" = 'Y' || "$PORTQUESTION" = 'y' ]]; then
     read -p 'Enter Port Number ' -e PORT
      fi
      echo Would you like to set a custom username? [DEFAULT=ROOT]
    read -p 'Y/N ' -e NAMEQUESTION
     if [[ "$PORTQUESTION" = 'Y' || "$NAMEQUESTION" = 'y' ]]; then
     read -p 'Enter Port Number ' -e USR
      fi
    ##Check for existance of folder.##
     if test -d /usr/bin/betterssh/ServerConnections
     then
     echo
    ##
    else
     sudo mkdir /usr/bin/betterssh/ServerConnections/
     echo Folder Created
      fi
    ## Create File ##
    FILE="/usr/bin/betterssh/ServerConnections/$NAME.sh"
    sudo /bin/cat <<-EOM >>$FILE
    #!/bin/bash
    sudo sshpass -p $PASS ssh -o StrictHostKeyChecking=no -p $PORT $USR@$HOST
EOM
   ## Encrypt File ##
   LOC="/usr/bin/betterssh/ServerConnections/$NAME"
bash-obfuscate "$LOC".sh -o "$LOC"ob1.sh
sed -i '1i #!/bin/bash' "$LOC"ob1.sh
##Add $!/bin/bash to top of file
bash-obfuscate "$LOC"ob1.sh -o "$LOC"ob2.sh
rm "$LOC"ob1.sh
sed -i '1i #!/bin/bash' "$LOC"ob2.sh
sudo shc -v -r -U  -f "$LOC"ob2.sh
rm "$LOC"ob2.sh
sleep 1;
cp "$LOC"ob2.sh.x "$LOC".server
rm "$LOC"ob2.sh.x
rm "$LOC"ob2.sh.x.c
rm "$LOC".sh
LogInput="$LOC.server Added at "
func_logEvent  

 clear
sudo bash ${0}
##

}
mmOp2 () {
echo 'Which server would you like to connect to?'
    ls /usr/bin/betterssh/ServerConnections | egrep '\.server$'
    read -p '' -e CONNECT
	LogInput="Attempting to connect to $CONNECT now at "
    func_logEvent
     if test -f /usr/bin/betterssh/ServerConnections/$CONNECT
        then
        /usr/bin/betterssh/ServerConnections/$CONNECT
        else 
       /usr/bin/betterssh/ServerConnections/$CONNECT.server
     fi 
}
mmOp3 () {
ls /usr/bin/betterssh/ServerConnections | egrep '\.server$'
 echo Would you like to remove an existing server? 
 read -p 'Y/N ' -e Rem
  if [[ "$Rem" = 'Y' || "$Rem" = 'y' ]]; then
 read -p 'Which server would you like to remove? ' -e FILE
     if test -f /usr/bin/betterssh/ServerConnections/$FILE
        then
		LogInput="Removing $FILE at "
   func_logEvent 
        rm /usr/bin/betterssh/ServerConnections/$FILE
        else 
       rm /usr/bin/betterssh/ServerConnections/$FILE.server
     fi 
 else
#restart#
clear
sudo bash ${0}
fi
##

}



##End MM Functions##

func_mainMenu () {
echo "$(tput setaf 2)"
echo -e "
Welcome to the Better Linux SSH Management System\n\n\
1)Add a new Server\n\
2)Connect to an existing Server\n\
3)List existing Server(s) / Remove\n\
4)Exit\n\
"
read -p '' -e MenuProcessor
echo "$(tput sgr0)"
if [[ "$MenuProcessor" = '1' ]]; then
mmOp1
fi
if [[ "$MenuProcessor" = '2' ]]; then 
mmOp2
fi
if [[ "$MenuProcessor" = '3' ]]; then
mmOp3
fi
if [[ "$MenuProcessor" = '4' ]]; then
func_logEvent
LogInput="Exit Function Executed at "
exit
fi
}
func_autoUpdate
func_requiredRepos
func_mainMenu
