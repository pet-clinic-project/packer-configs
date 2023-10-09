#!/bin/bash

JAR_FILE=/home/ubuntu/petclinic-1.0.15.jar
APP_PROPERTIES=/opt/application.properties
PROPERTIES_SCRIPT=/home/ubuntu/properties.py

# download from s3
aws s3 cp s3://petclinic-project/jar/jmx_prometheus_javaagent-0.18.0.jar /home/ubuntu/jmx_prometheus_javaagent-0.18.0.jar

# download from nexus
credentials=$(aws secretsmanager get-secret-value --secret-id dev/nexus-login --region us-west-2 --query SecretString --output json)

username=$(echo "$credentials" | jq -r '.["username"]')
password=$(echo "$credentials" | jq -r '.["password"]')

curl -u "$username:$password" -O http://54.244.121.108:8081/repository/maven-releases/org/pet-clinic/1.0.15/pet-clinic-1.0.15.jar /home/ubuntu

# to run python script
sudo python3 ${PROPERTIES_SCRIPT}

# start jmx and petclinic application jar file
sudo java -jar ${JAR_FILE} --spring.config.location=${APP_PROPERTIES} --spring.profiles.active=mysql & \
java -javaagent:/home/ubuntu/jmx_prometheus_javaagent-0.18.0.jar=9090:/home/ubuntu/config.yml -jar ${JAR_FILE} &