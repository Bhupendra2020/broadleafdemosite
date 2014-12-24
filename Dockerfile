#Build this dockerfile :  docker build -t fnubhupen/broadleaf git://github.com/Bhupendra2020/broadleafdemosite.git

FROM ubuntu:trusty
MAINTAINER Bhupendra Kumar <Bhupendra.kumar@softcrylic.com>

# update package respository
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN echo "deb http://archive.ubuntu.com/ubuntu precise-security main universe" > /etc/apt/sources.list
RUN apt-get update

# install java, tomcat7
RUN apt-get install -y default-jdk
RUN apt-get install -y tomcat7

RUN mkdir /usr/share/tomcat7/logs/
RUN mkdir /usr/share/tomcat7/temp/

# set tomcat environment variables
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV JRE_HOME=/usr/lib/jvm/default-java/jre
ENV CATALINA_HOME=/usr/share/tomcat7/

#Install the Tomcat7
#RUN apt-get update && \
#    apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
#    apt-get clean && \
#   rm -rf /var/lib/apt/lists/*

#ENV TOMCAT_MAJOR_VERSION 7
#ENV TOMCAT_MINOR_VERSION 7.0.57
#ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
#RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
#    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
#    tar zxf apache-tomcat-*.tar.gz && \
#    rm apache-tomcat-*.tar.gz && \
#    mv apache-tomcat* tomcat

#ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
#ADD run.sh /run.sh
#RUN chmod +x /*.sh

# Install maven
RUN apt-get update
RUN apt-get install -y maven

WORKDIR /code

# Prepare by downloading dependencies
ADD pom.xml /code/pom.xml
ADD build.xml /code/build.xml
ADD admin /code/admin
ADD core /code/core
ADD site /code/site
ADD lib /code/lib
ADD testing /code/testing

#Download Maven Dependencies
#RUN ["mvn", "dependency:resolve"]
#RUN ["mvn", "verify"]

# Adding source, compile and package into a fat war
RUN ["mvn", "clean"]
RUN ["mvn", "install"]

WORKDIR /code/site/target

# Add your webapp file into your docker image into Tomcat's webapps directory
# Your webapp file must be at the same location as your Dockerfile
#ADD mycompany.war /tomcat/webapps/

#EXPOSE 8080
#CMD ["/run.sh"]

# copy war files to the webapps/ folder
ADD mycompany.war /usr/share/tomcat7/webapps/

# launch tomcat once the container started
#ENTRYPOINT service tomcat7 start
#ENTRYPOINT /usr/share/tomcat7/bin/catalina.sh run

# expose the tomcat port number
#EXPOSE 8080
