# Overview of the OpenTelemetry Framework

## Signal Specification (Language-Agnostic)

On a high level, OpenTelemetry is organized into signals, which mainly include tracing, metrics and logging. 

- Every signal is developed as a standalone component. 
- Signals are defined inside OpenTelemetry’s language-agnostic specification, which lies at the very heart of the project.

The specification consists of three parts. 

1. Definitions of terms that establish a common vocabulary and shared understanding to avoid confusion. 
2. It specifies the technical details of how each signal is designed. This includes:
    - an API specification
    - an SDK specification
3. Besides signal architecture, the specification also covers aspects related to telemetry data. 
    - For example, OpenTelemetry defines semantic conventions.

## Vendor-Agnostic, Language-Specific Instrumentation

To generate and emit telemetry from applications, we use **language-specific implementations**, which adhere to OpenTelemetry’s specification. The implementation of a signal consists of two parts:

1. API
    - defines the interfaces and constants outlined in the specification
    - used by application and library developers for vendor-agnostic instrumentation
    - refers to a no-op implementation by default
2. SDK
    - provider implements the OpenTelemetry API
    - contains the actual logic to generate, process and emit telemetry
    - OpenTelemetry ships with official providers that serve as the reference implementation (commonly referred to as the SDK)
    - it is possible to write your own

Generally speaking, we use the OpenTelemetry API to add instrumentation to our source code. In practice, this can be achieved in various ways, such as:

- zero-code or automatic instrumentation
- instrumentation libraries that provide simplified OpenTelemetry integration
- manual or code-based instrumentation

### Why OpenTelemetry decided to separate the API from the SDK

- On startup, the application registers a provider for every type of signal. 
- After that, calls to the API are forwarded to the respective provider. 
- If we don’t explicitly register one, OpenTelemetry will use a fallback provider that translates API calls into no-ops.

The primary reason for separating the API from the SDK is that it makes it easier to embed native instrumentation into open source library code. 
- OpenTelemetry’s API is designed to be lightweight and safe to depend on. 
- The signal’s implementation provided by the SDK is significantly more complex and likely contains dependencies on other software. Forcing these dependencies on users could lead to conflicts with their particular software stack. 
- Registering a provider during the initial setup allows users to resolve dependency conflicts by choosing a different implementation. 
- Furthermore, it allows us to ship software with built-in observability without forcing the runtime cost of instrumentation onto users that don’t need it.

## Telemetry Processor (Standalone Component)

After generating and emitting telemetry, operators are responsible for managing and ingesting it into the respective backends. This includes tasks such as:

- gathering data from various sources
- parsing and converting it for downstream processing
- enrichment with additional metadata
- filtering out irrelevant data to reduce noise and storage requirements
- normalization and applying transformations
- buffering for resilience and performance
- routing to steer subsets of telemetry to different destinations
- forwarding to backends

To build and configure such telemetry pipelines, operations teams often deploy additional infrastructure. OpenTelemetry provides a standalone component with these capabilities: **the OpenTelemetry Collector**.

## Wire Protocol

OpenTelemetry also defines how to transport telemetry between producers, agents, and backends.

**The OpenTelemetry Protocol (OTLP)** is an open source and vendor-neutral wire format that defines:

- how data is encoded in memory
- a protocol to transport that data across the network

OTLP is used throughout the observability stack. 

- Emitting telemetry in OLTP means that instrumented applications and third-party services are compatible with countless observability solutions. 
- The Collector supports receiving telemetry from and exporting to a various formats. OTLP is generally preferred because the Collector uses it internally to represent and process telemetry. Thereby, we avoid the cost of converting between formats and increase consistency. The native format closely aligns with the ideas proposed by the framework (having attributes follow semantic conventions, cross-signal correlation, etc.).

### OTLP Transport Mechanisms

OTLP offers three transport mechanisms for transmitting telemetry data: 

1. HTTP/1.1 
2. HTTP/2
3. gRPC. 

When using OTLP, the choice of transport mechanism depends on application requirements, considering factors such as performance, reliability, and security. 

### OTLP data encoding

OTLP data is often encoded using the **Protocol Buffers (Protobuf)** binary format, which is compact and efficient for network transmission and supports schema evolution, allowing for future changes to the data model without breaking compatibility. 

Data can also be encoded in the JSON file format, which allows for a human-readable format with the disadvantage of higher network traffic and larger file sizes.