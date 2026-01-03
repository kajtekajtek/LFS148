# Why Do We Need OpenTelemetry?

## How We Got Here

### Observability

According to Wikipedia, 

> "observability is a measure of how well the internal states of a system can be inferred from knowledge of its external outputs" (2024). 

In other words, observability refers to **how easily you can understand what's happening inside a system by looking at the information it produces**.

### Distributed Systems

A distributed system is a **network of independent computers, or nodes, working together to perform tasks as if they were a single system**.

To make a distributed system observable, we must model its state in a way that lets us reason about its behavior:

1. **Workload**. These are the operations a system performs to fulfill its objectives. This is also often referred to as transactions.
2. **Software abstractions** that make up the structure of the distributed system. Load balancers, services, pods, containers and more.
3. **Physical machines** that provide computational resources (e.g. RAM, CPU, disk space, network) to carry out work.

### Logs

A **log** is an append-only data structure that records events occurring in a system. A log entry consists of a timestamp that denotes when something happened and a message to describe details about the event. 

Apart from content, log formats also vary with their consumers. As software systems became more complex, the volume of logs soon became unmanageable. To combat this, we started **encoding events as key/value pairs to make them machine-readable**, which is commonly known as **structured logging**. 

Moreover, the distribution and ephemeral nature of containerized applications meant that it was no longer feasible to log onto individual machines and sift through logs. As a result, people started to build logging agents and protocols to forward logs to dedicated services. These logging systems allowed for efficient storage as well as the ability to search and filter logs in a central location.

### Metrics

A **metric** is a single numerical value derived by applying a statistical measure to a group of events. Metrics represent an aggregate. Their compact representation allows us to graph how a system changes over time.

The four common types of metrics: 
- counters
- gauges
- histograms
- summaries

### Traces

On a fundamental level, **tracing** is logging on steroids. The underlying idea is to **add transactional context to logs**. This makes it possible to infer causality and **reconstruct the journey of requests in the system.**

### Three Pillars Of Observability

Having dedicated systems for **logs, metrics, and traces** is why we commonly refer to them as **the three pillars of observability**. The notion of pillars provides a great mental framework because it emphasizes the following:

- There are different categories of telemetry
- Each pillar has its own unique strengths and stands on its own
- Pillars are complementary and must be combined to form a stable foundation for achieving observability

## OpenTelemetry

### What is OpenTelemetry?

**OpenTelemetry** (OTel) is an open source project designed to provide standardized tools and APIs for generating, collecting, and exporting telemetry data such as traces, metrics, and logs. It aims to give developers deep visibility into applications, helping to monitor, troubleshoot, and optimize software systems.

The main goals of OpenTelemtry are:

- **Unified telemetry**: Combines tracing, logging, and metrics into a single framework enabling correlation of all data and establishing an open standard for telemetry data.
- **Vendor-neutrality**: Integration with different backends for processing the data.
- **Cross-platform**: Supports various languages (Java, Python, Go, etc.) and platforms, making it versatile for different development environments.

### What OpenTelemetry is NOT

OpenTelemetry is:

- Not an All-in-One Monitoring or Observability Tool
    - OpenTelemetry doesn't replace full-fledged monitoring or observability platforms. Instead, it helps collect and standardize telemetry data (traces, metrics, logs) so that you can send it to these tools for visualization and analysis.
- Not a Data Storage or Dashboarding Solution
    - OpenTelemetry doesn’t store or visualize data.
- Not a Pre-configured Monitoring Tool
    - OpenTelemetry is a toolkit for collecting and exporting data, but it requires configuration and integration with other systems.
- Not a Performance Optimizer
    - While OpenTelemetry helps you collect detailed performance data, it doesn’t automatically optimize application performance.

In essence, **OpenTelemetry is an integration and standardization tool for telemetry data, not an all-in-one solution for monitoring, logging, or performance management**.