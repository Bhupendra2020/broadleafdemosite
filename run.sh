#!/bin/bash

#!/bin/sh
#DIR=${DEPLOY_DIR:-/maven}
#echo "Checking *.war in $DIR"
#if [ -d $DIR ]; then
#  for i in $DIR/*.war; do
#     file=$(basename $i)
#     echo "Linking $i --> /tomcat/webapps/$file"
#     #ln -s $i /tomcat/webapps/$file
#     cp $DIR/$file /tomcat/webapps/$file
#  done
#fi

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

exec ${CATALINA_HOME}/bin/catalina.sh run
