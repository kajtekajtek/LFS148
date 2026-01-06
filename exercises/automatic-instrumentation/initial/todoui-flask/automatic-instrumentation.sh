#!/bin/bash

CONFIG_FILE=.config

function load_configuration() {
    echo "===> Loading the configuration..."
    source .config
    if [ ! -f .config ]; then
        echo "===> Configuration file not found."
        exit 1
    fi
    cat $CONFIG_FILE
    echo -e "\n===> Configuration loaded successfully."
}

function install_opentelemetry_instrument() {
    if [ $(which opentelemetry-instrument) ]; then
        echo "===> opentelemetry-instrument already installed."
        return
    fi

    echo "===> Installing opentelemetry-instrument..."
    opentelemetry-bootstrap --action=install
    if [ $? -ne 0 ]; then
        echo "===> Failed to install opentelemetry-instrument."
        exit 1
    fi
    pip uninstall opentelemetry-instrumentation-aws-lambda || true

    echo "===> opentelemetry-instrument installed successfully."
}

function main() {
    load_configuration
    install_opentelemetry_instrument
    opentelemetry-instrument python app.py
}

main
