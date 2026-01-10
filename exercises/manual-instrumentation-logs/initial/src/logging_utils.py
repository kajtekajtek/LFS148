from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk._logs.export import ConsoleLogExporter, SimpleLogRecordProcessor
from opentelemetry.sdk.resources import Resource

logger_provider = LoggerProvider(
    resource=Resource.create(
    {
        "service.name": "example-app",
    }
    ),
)

record_processor = SimpleLogRecordProcessor(
    exporter=ConsoleLogExporter()
)
logger_provider.add_log_record_processor(record_processor)
handler = LoggingHandler(logger_provider=logger_provider)