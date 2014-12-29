#Build this dockerfile :  docker build -t fnubhupen/broadleaf git://github.com/Bhupendra2020/broadleafdemosite.git

FROM fnubhupen/oraclejava:7
MAINTAINER Bhupendra Kumar <Bhupendra.kumar@softcrylic.com>

#Install the Tomcat7
RUN apt-get update && \
    apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
    apt-get clean && \
   rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.57
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

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
#RUN ["mvn", "clean"]
#RUN ["mvn", "install"]

# Add your webapp file into your docker image into Tomcat's webapps directory
# Your webapp file must be at the same location as your Dockerfile
ADD ./site/target/mycompany.war /tomcat/webapps/mycompany.war

EXPOSE 8080
CMD ["/run.sh"]



