#!/bin/bash

REGION=us-west-2
SECRET_ID=dev/nexus-login
WORKING_DIR=/home/ubuntu
NEXUS_URL=http://54.244.121.108:8081
ARTIFACT_ID=pet-clinic
ARTIFACT_VERSION=1.0.18
APP_PROPERTIES=/opt/application.properties
PROPERTIES_SCRIPT=properties.py

# download from s3
aws s3 cp s3://petclinic-project/jar/jmx_prometheus_javaagent-0.18.0.jar "${WORKING_DIR}/jmx_prometheus_javaagent-0.18.0.jar"

# download from nexus
credentials=$(aws secretsmanager get-secret-value --secret-id "${SECRET_ID}" --region "${REGION}" --query SecretString --output json)

username=$(echo "$credentials" | jq -r '.["username"]')
password=$(echo "$credentials" | jq -r '.["password"]')

curl -u "${username}:${password}" -o "${WORKING_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.jar" "${NEXUS_URL}/repository/maven-releases/org/${ARTIFACT_ID}/${ARTIFACT_VERSION}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.jar"

sudo systemctl restart consul.service

# to run python script
sudo python3 "${WORKING_DIR}/${PROPERTIES_SCRIPT}"

# start jmx and petclinic application jar file
sudo java -jar "${WORKING_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.jar" --spring.config.location="${APP_PROPERTIES}" --spring.profiles.active=mysql & \
java -javaagent:"${WORKING_DIR}/jmx_prometheus_javaagent-0.18.0.jar"=9090:"${WORKING_DIR}/config.yml" -jar "${WORKING_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.jar" &
