from opentelemetry.sdk.resources import Resource
from opentelemetry.semconv.resource import ResourceAttributes

"""
A resource is a set of static attributes that help us identify the source 
(and location) that captured a piece of telemetry.
"""
def create_resource(name: str, version: str) -> Resource:
    svc_resource = Resource.create(
        {
            ResourceAttributes.SERVICE_NAME: name,
            ResourceAttributes.SERVICE_VERSION: version,
        }
    )
    return svc_resource