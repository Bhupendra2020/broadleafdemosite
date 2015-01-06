#copy the site war to main root of Jenkins
rm -rf deploy
mkdir deploy
cp ./site/target/mycompany.war ./deploy/

# Run the Docker
sudo docker pull fnubhupen/tomcat7
sudo docker run -d -p 490$BUILD_NUMBER:8080 --name $JOB_NAME$BUILD_NUMBER -e TOMCAT_PASS="mypass" -v $WORKSPACE/deploy:/maven fnubhupen/tomcat7
