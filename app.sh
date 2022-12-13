#!/bin/bash

# Input TOKEN and project name provided by Server
echo -e "Welcome to our automatically Tester"
echo -e "Please input token: \c"
read token

echo -e "Please input project name: \c"
read name

# Check for container existence and run sonarqube container 
if [ ! "$(docker ps -q -f name=sonarqube)" ]; then
	if [ "$(docker ps -aq -f status=exited -f name=sonarqube)" ]; then
		docker rm -f sonarqube
	fi
	docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
fi

# Create a configuration file
touch sonar-project.properties

echo -e "sonar.projectKey=$name \nisonar.projectName=$name \nsonar.projectVersion=1.0 \nsonar.sources=. \nsonar.sourceEncoding=UTF-8" > sonar-project.properties

# Connect to the Server
docker run --rm --link sonarqube -e SONAR_HOST_URL="http://192.168.64.13:9000" -e SONAR_LOGIN="$token" -v ${PWD}:/usr/src sonarsource/sonar-scanner-cli

