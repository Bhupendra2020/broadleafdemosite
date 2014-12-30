#Build this dockerfile :  docker build -t fnubhupen/broadleaf git://github.com/Bhupendra2020/broadleafdemosite.git

FROM fnubhupen/oraclejava:7
MAINTAINER Bhupendra Kumar <Bhupendra.kumar@softcrylic.com>

#Install the Tomcat7
RUN sudo apt-get update && \
    sudo apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.57
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN sudo wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    sudo wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    sudo tar zxf apache-tomcat-*.tar.gz && \
    sudo rm apache-tomcat-*.tar.gz && \
    sudo mv apache-tomcat* tomcat

sudo ADD /create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
sudo ADD  /setenv.sh /${CATALINA_HOME}/bin/setenv.sh
sudo ADD  /run.sh /run.sh
 RUN  sudo chmod +x /*.sh


ADD sudo mycompany.war /tomcat/webapps/mycompany.war

EXPOSE 8080
CMD ["sudo /run.sh"]



