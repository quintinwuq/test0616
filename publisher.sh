NS_TRANSFER_FOLDER="/opt/jenkins"
TOMCAT_PORT=8080
PROJECT="fuyhui"
TOMCAT_HOME="/usr/local/tomcat-fyhtest"
CONFIG_SET="/opt/test-seting"

################################################################
#param validate
echo "------------------------------------start param validate------------------------------------------------------------------------------"
if [ $# -lt 1 ]; then
  echo "you must use like this :  sh publisher.sh  [PROJECT] [TOMCAT_PORT] [TOMCAT_HOME]"  
  #exit
fi
if [ $PROJECT != "" ]; then
	PROJECT="fuyhui"
else
	PROJECT="fuyhui"
fi
if [ $TOMCAT_PORT != "" ]; then
   TOMCAT_PORT=8080
fi
if [ $TOMCAT_HOME != "" ]; then
   TOMCAT_HOME="/usr/local/tomcat-fyhtest"
   #cd $TOMCAT_HOME/webapps/ROOT/WEB-INF/classes/
   #cp $TOMCAT_HOME/webapps/ROOT/WEB-INF/classes/wx-web.properties $TOMCAT_HOME/webapps/ROOT/WEB-INF/classes/jdbc.properties /opt/jenkins_transfer_folder/wap_conf_bak
   
   rm -rf $TOMCAT_HOME/webapps/$PROJECT*
 # else
	#cd /opt/jrl/wapsit_apache-tomcat-7.0.56/webapps/$PROJECT/WEB-INF/classes/
	#cp $TOMCAT_HOME/webapps/ROOT/WEB-INF/classes/wx-web.properties $TOMCAT_HOME/webapps/ROOT/WEB-INF/classes/jdbc.properties /opt/jenkins_transfer_folder/wap_conf_bak
	#rm -rf /opt/jrl/wapsit_apache-tomcat-7.0.56/webapps/$PROJECT*
	
   fi
#echo "params : PROJECT='fuyhui'    TOMCAT_PORT=8080      TOMCAT_HOME: /usr/local/tomcat-fyh_test/webapps/"


echo "------------------------------------end param validate------------------------------------------------------------------------------"

###############################################################
#shutdown tomcat


echo "------------------------------------start shutdown tomcat first---------------------------------------------------------------------"
#check tomcat process
tomcat_pid=`lsof -n -P -t -i :$TOMCAT_PORT`
echo "current :" "$tomcat_pid"
while [ -n "$tomcat_pid" ]
do
	"$TOMCAT_HOME"/bin/shutdown.sh
	sleep 2
	tomcat_pid=`lsof -n -P -t -i :$TOMCAT_PORT`
	echo "---scan tomcat pid :" $tomcat_pid
	kill -9 `lsof -n -P -t -i :$TOMCAT_PORT`
	echo "Kill it ~~"
done
echo "tomcat had shutdown~~"
echo "------------------------------------end shutdown tomcat first------------------------------------------------------------------------------"

#################################################################
#publish project
echo "------------------------------------start publisher------------------------------------------------------------------------------"
echo $PROJECT " publishing~~~"
rm -rf $TOMCAT_HOME/webapps/$PROJECT*
sleep 2
#cp /opt/jenkins_transfer_folder/$PROJECT*.war "$TOMCAT_HOME"/webapps/$PROJECT.war
 cp  "$NS_TRANSFER_FOLDER"/"$PROJECT".war   "$TOMCAT_HOME"/webapps/"$PROJECT".war
 
# cp /opt/jenkins/"$PROJECT".war  /usr/local/tomcat-fyh_test/webapps/"$PROJECT".war
sleep 2
echo "copy OK~~~"
#bak project

#mkdir $NS_TRANSFER_FOLDER/bak
BAK_DIR=$NS_TRANSFER_FOLDER/bak/$PROJECT/`date +%Y%m%d`
mkdir -p "$BAK_DIR"
sudo cp -rf "$TOMCAT_HOME"/webapps/"$PROJECT".war  "$BAK_DIR"/"$PROJECT"_`date +%H%M%S`.war
sleep 2
#remove tmp
rm -rf $NS_TRANSFER_FOLDER/$PROJECT*.war
sleep 1
echo "bakup & remove OK~~~"
echo "------------------------------------end publisher------------------------------------------------------------------------------"
#start tomcat
"$TOMCAT_HOME"/bin/startup.sh



sleep 15
echo "------------------------------------start tomcat before publisher--------------------------------------------------------------"


echo "------------------------------------start shutdown tomcat second---------------------------------------------------------------------"
#check tomcat process
tomcat_pid=`lsof -n -P -t -i :$TOMCAT_PORT`
echo "current :" "$tomcat_pid"
while [ -n "$tomcat_pid" ]
do
	"$TOMCAT_HOME"/bin/shutdown.sh
	sleep 2
	tomcat_pid=`lsof -n -P -t -i :$TOMCAT_PORT`
	echo "---scan tomcat pid :" $tomcat_pid
	kill -9 `lsof -n -P -t -i :$TOMCAT_PORT`
	echo "Kill it ~~"
done
echo "tomcat had shutdown~~"
echo "------------------------------------end shutdown tomcat second------------------------------------------------------------------------------"



echo "------------------------------------更换测试环境配置文件-----------------------------------------------------------------------"

cp -rf  "$CONFIG_SET"/common.js  "$TOMCAT_HOME"/webapps/"$PROJECT"/static/scripts/common/common.js

cp -rf "$CONFIG_SET"/filePath.properties    "$TOMCAT_HOME"/webapps/"$PROJECT"/WEB-INF/classes/config/filePath.properties

cp -rf "$CONFIG_SET"/FyUtil.class    "$TOMCAT_HOME"/webapps/"$PROJECT"/WEB-INF/classes/com/fujfu/common/payment/fuyou/util/FyUtil.class

cp -rf "$CONFIG_SET"/spring-test-config.xml   "$TOMCAT_HOME"/webapps/"$PROJECT"/WEB-INF/classes/spring/spring-test-config.xml

cp -rf "$CONFIG_SET"/web.xml       "$TOMCAT_HOME"/webapps/"$PROJECT/"WEB-INF/web.xml

rm -rf "$TOMCAT_HOME"/webapps/ROOT

rm -rf "$TOMCAT_HOME"/work/Catalina/localhost/*


echo "------------------------------------配置文件替换成功-------------------------------------------------------------------------------------"


#start tomcat
#"$TOMCAT_HOME"/bin/startup.sh

#echo "tomcat started!"
#echo "------------------------------------start tomcat second-------------------------------------------------------------------------------------"


##########
##################################################################
#replace config files
#echo "------------------------------------------start replace config file------------------------------------------------------------------------"
sleep 4
#cd /opt/jenkins_transfer_folder/wap_conf_bak
#yes | cp -f /opt/jenkins_transfer_folder/wap_conf_bak/wx-web.properties /opt/jenkins_transfer_folder/wap_conf_bak/jdbc.properties $TOMCAT_HOME/webapps/$PROJECT/WEB-INF/classes/
#sleep 1
#echo "Have replace config file~~~"
#echo "------------------------------------end replace config file------------------------------------------------------------------------------"
##################################################################
#shutdown tomcat
echo "------------------------------------start shutdown tomcat twice------------------------------------------------------------------------------"
#"$TOMCAT_HOME"/bin/shutdown.sh
#echo "shutdown twice~~~~"
#check tomcat process
tomcat_pid=`lsof -n -P -t -i :$TOMCAT_PORT`
echo "current :" $tomcat_pid
while [ -n "$tomcat_pid" ]
do
 sleep 2
 tomcat_pid=`lsof -n -P -t -i :$TOMCAT_PORT`
 echo "---scan tomcat pid :" $tomcat_pid
 if [ $tomcat_pid != "" ]; then
	kill -9 `lsof -n -P -t -i :$TOMCAT_PORT`
 fi
done
echo "------------------------------------end shutdown tomcat twice------------------------------------------------------------------------------"
echo "------------------------------------start start tomcat twice------------------------------------------------------------------------------"
"$TOMCAT_HOME"/bin/startup.sh
##################################################################
echo "tomcat is starting,please try to access $PROJECT console url"
echo "------------------------------------start start tomcat twice------------------------------------------------------------------------------"

