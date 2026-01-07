from opentelemetry.sdk.trace.export import ConsoleSpanExporter, BatchSpanProcessor
from opentelemetry import trace as trace_api
from opentelemetry.sdk.trace import TracerProvider
from resource_utils import create_resource

def create_tracer(name: str, version: str) -> trace_api.Tracer:
    # attach resource to the tracer provider
    provider = TracerProvider(
        resource=create_resource(name, version)
    )
    # connect provider to the tracing pipeline
    provider.add_span_processor(create_tracing_pipeline())
    # register a tracer provider instead of using a no-op
    trace_api.set_tracer_provider(provider)
    tracer = trace_api.get_tracer(name, version)
    return tracer

def create_tracing_pipeline() -> BatchSpanProcessor:
    # exporter for writing spans to the console
    console_exporter = ConsoleSpanExporter()
    # asynchronous processor for batching spans and sending them to the exporter
    span_processor = BatchSpanProcessor(console_exporter)
    return span_processor