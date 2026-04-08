# Generic CMS adapter contract

This adapter is the handoff point between `website-publishing` and a real CMS.

Recommended implementation styles:
- HTTP webhook wrapper
- queue consumer
- direct SDK client

Use `publish_request.schema.json` and `publish_response.schema.json` as the stable contract.
