# Instrumentation

## What is instrumentation?

Instrumentation refers to the process of adding code or using tools to collect telemetry data from an application.

- It means you add something to your application code, which turns a non-observed application into an application that emits data from within the application.
- This data provides insights into how the application behaves at runtime, helping developers monitor performance, diagnose issues, and understand overall system health.

It enables the collection of telemetry signals that allow observability tools to track and visualize how an application and its components are performing. 

### Instrumentation is often highly dependent on the programming language and framework in use. 

Instrumentation code tends to be proprietary, tailored to the specific tools, libraries, and architecture of each application. 

As a result, developers must often implement custom instrumentation for each language or framework they work with, which can lead to challenges in maintaining consistency across different parts of a system, especially in polyglot (multi-language) environments.

It also means that the more specific the information you want to extract from your application, the more specific your instrumentation effort has to be.

The instrumentation also defines which kind of telemetry signals are being handled.

## Different Instrumentation Types

### Automatic Instrumentation (or zero-code)

- **No code changes required**: Automatically instruments applications without modifying the source code.
- **Typically provided by OpenTelemetry agents or plugins**: These agents attach to the runtime of the application and automatically collect telemetry data.
- **Ideal for quick setup**: It works out of the box and is used to gather traces, metrics, and logs without manual intervention.
- **Less granular control**: While easy to use, automatic instrumentation may not offer as much fine-tuning or customization as manual instrumentation.

Examples:

- OpenTelemetry agents for Java or Python, which can automatically instrument common libraries like HTTP, databases, or messaging systems.

### Instrumentation Libraries (potentially code-based)

- **May require minimal code changes**: Libraries are often specific to a programming language or framework and are integrated by importing them into the code. Some libraries provide easy integration with minimal configuration, while others might need manual intervention.
- **Provides more flexibility**: They allow you to add instrumentation where automatic methods may not reach or to extend it with custom logic.
- **Control over integration**: You can use libraries to instrument specific parts of an application in more detail.

Examples:

- OpenTelemetry instrumentation libraries for specific frameworks like Django (Python) or Spring (Java), where you might need to configure middleware or wrap methods to enable tracing or metrics.

### Manual Instrumentation (fully code-based)

- **Requires explicit code changes**: Manual instrumentation involves directly adding OpenTelemetry API calls in the source code.
- **Fine-grained control**: It gives developers full control over what gets instrumented, how it is measured, and what data is collected. You can choose exactly where to start and end traces, log specific events, or capture custom metrics.
- **Customization**: It is the most flexible approach, allowing developers to instrument any part of the application, regardless of whether automatic or library-based options are available.
- **More effort and maintenance**: Manual instrumentation takes more time to implement and maintain, as developers need to explicitly manage spans, metrics, and logging points in the code.

Examples:

- Using OpenTelemetry's API to define custom spans, attributes, or events, such as manually wrapping a specific block of code in a custom trace.
- Adding custom metrics that are not automatically captured, such as counting how many times a particular business function is called.
