# nginx-extras

This repository provides some NGINX utility configuration templates.

## Environment variables

Ideally, these variables should be substituted using `envsubst`.

- `J3_INFO_GROUP`: the application group.
- `J3_INFO_ARTIFACT`: the artifact name.
- `J3_INFO_NAME`: the application name.
- `J3_INFO_VERSION`: the artifact version.
- `J3_IRN`: the Infrastructure Resource identifier.
- `J3_MONITORING_PORT`: the monitoring port.

## Configuration templates

- [00-vars.conf.template](./src/main/dist/templates/00-vars.conf.template)

This configuration file provides variables deduced from the environment context, as well as utility variables.

- [01-proxy.conf.template](./src/main/dist/templates/01-proxy.conf.template)

This configuration file provides default proxy configuration when using an upstream.

- [02-optimization.conf.template](./src/main/dist/templates/02-optimization.conf.template)

This configuration file provides global optimization to the NGinx instance.

- [03-http-tracing.conf.template](./src/main/dist/templates/03-http-tracing.conf.template)

This configuration file configure tracing via `x-request-id` header propagation.
In addition, it generates a value if the header has not been passed in the request.

- [04-monitoring.conf.template](./src/main/dist/templates/04-monitoring.conf.template)

This configuration file bootstraps a monitoring configuration listening on `MONITORING_PORT`.
This configuration provides a `/health`, `/info`, and `/stub_status` endpoints.

- [05-json-logging.conf.template](./src/main/dist/templates/05-json-logging.conf.template)

This configuration file provides access logs under JSON format.