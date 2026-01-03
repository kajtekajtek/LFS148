#!/bin/bash

JAVA_VERSION=21
CONFIG_FILE=.config
OTEL_JAVA_AGENT_FILENAME=opentelemetry-javaagent.jar
OTEL_JAVA_AGENT_URL=https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.8.0/opentelemetry-javaagent.jar

echo "Checkihng java version..."
if [ $(java -version 2>&1 | grep -c ${JAVA_VERSION}) -eq 0 ]; then
    echo "Java ${JAVA_VERSION} is required."
    exit 1
fi


echo "Loading the configuration..."
source ${CONFIG_FILE}

if [ ! -f ${CONFIG_FILE} ]; then
    echo "Configuration file not found."
    exit 1
fi

# verify environment variables are set
echo "OpenTelemetry configuration:"
echo "  OTEL_SERVICE_NAME=${OTEL_SERVICE_NAME}"
echo "  OTEL_TRACES_EXPORTER=${OTEL_TRACES_EXPORTER}"
echo "  OTEL_METRICS_EXPORTER=${OTEL_METRICS_EXPORTER}"
echo "  OTEL_LOGS_EXPORTER=${OTEL_LOGS_EXPORTER}"

# build the app
mvn clean package

# download the OpenTelemetry Java agent
wget ${OTEL_JAVA_AGENT_URL} \
    -O ${OTEL_JAVA_AGENT_FILENAME}

if [ ! -f ${OTEL_JAVA_AGENT_FILENAME} ]; then
    echo "Failed to download the OpenTelemetry Java agent"
    exit 1
fi

# run the app with the OpenTelemetry Java agent
java --add-opens java.base/java.lang=ALL-UNNAMED \
    -javaagent:${OTEL_JAVA_AGENT_FILENAME} \
    -jar target/todobackend-0.0.1-SNAPSHOT.jar

java -javaagent:${OTEL_JAVA_AGENT_FILENAME} -jar target/todobackend-0.0.1-SNAPSHOT.jar