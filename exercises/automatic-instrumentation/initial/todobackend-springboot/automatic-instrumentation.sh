#!/bin/bash

JAVA_VERSION=21
CONFIG_FILE=.config
OTEL_JAVA_AGENT_FILENAME=opentelemetry-javaagent.jar
OTEL_JAVA_AGENT_URL=https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.8.0/opentelemetry-javaagent.jar

function check_java_version() {
    echo "Checking java version..."
    if [ $(java -version 2>&1 | grep -c ${JAVA_VERSION}) -eq 0 ]; then
        echo "Java ${JAVA_VERSION} is required."
        exit 1
    fi
}


function load_configuration() {
    echo "Loading the configuration..."
    source ${CONFIG_FILE}
    if [ ! -f ${CONFIG_FILE} ]; then
        echo "Configuration file not found."
        exit 1
    fi
    echo "OpenTelemetry configuration:"
    echo "  OTEL_TRACES_EXPORTER=${OTEL_TRACES_EXPORTER}"
    echo "  OTEL_METRICS_EXPORTER=${OTEL_METRICS_EXPORTER}"
    echo "  OTEL_LOGS_EXPORTER=${OTEL_LOGS_EXPORTER}"
}

function build_application() {
    if [ ! -f target/todobackend-0.0.1-SNAPSHOT.jar ]; then
        echo "Building the application..."
        mvn clean package
    fi
}

function download_opentelemetry_java_agent() {
    if [ ! -f ${OTEL_JAVA_AGENT_FILENAME} ]; then
        echo "Downloading the OpenTelemetry Java agent..."
        wget ${OTEL_JAVA_AGENT_URL} \
            -O ${OTEL_JAVA_AGENT_FILENAME}
    fi
}

function check_opentelemetry_java_agent() {
    if [ ! -f ${OTEL_JAVA_AGENT_FILENAME} ]; then
        echo "File ${OTEL_JAVA_AGENT_FILENAME} not found."
        exit 1
    fi
}

function run_jaeger_docker_container() {
    echo "Running the Jaeger docker container..."
    docker run -d --name jaeger \
        -e COLLECTOR_OTLP_ENABLED=true \
        -p 16686:16686 \
        -p 14268:14268 \
        -p 4317:4317 \
        -p 4318:4318 \
        jaegertracing/all-in-one
    if [ -z $(docker ps -q -f name=jaeger) ]; then
        echo "Failed to run the Jaeger docker container."
        exit 1
    fi
}

function run_application() {
    java --add-opens java.base/java.lang=ALL-UNNAMED \
        -javaagent:${OTEL_JAVA_AGENT_FILENAME} \
        -jar target/todobackend-0.0.1-SNAPSHOT.jar
}

function clean_up() {
    echo "Cleaning up..."
    docker stop jaeger
    docker rm -f jaeger
}

function main() {
    trap clean_up EXIT
    check_java_version
    load_configuration
    build_application
    download_opentelemetry_java_agent
    check_opentelemetry_java_agent
    run_jaeger_docker_container
    run_application
}

main