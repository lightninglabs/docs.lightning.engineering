---
description: >-
  Several services bundled with Aperture allow you to manage and monitor your
  gateway
---

# Admin Services

Aperture comes bundled with a Command Line Interface (CLI), an admin Application Programming Interface (API) over REST and gRPC, a dashboard and a Model Context Protocol (MCP) server. They can be used to retrieve information about the performance of the gateway and manage its pricing dynamically.

## Configuration

To enable the Aperture Admin Services, the application needs to be compiled with the dashboard:

`make build-dashboard`\
`make build-withdashboard`

Next, the admin mode needs to be configured in the aperture.yaml:

```
admin:
	enabled: true
```

The changes will go into effect upon restart.

Aperture requires a macaroon to authenticate calls to the LND backend. The required permissions can be obtained using the command:

`lncli bakemacaroon invoices:read invoices:write offchain:write`

LND's standard `invoice.macaroon` is also sufficient.

## Command Line Interface

The CLI is available under the name `aperturecli`. If Aperture is running with a self-signed certificate, the path to the certificate will have to be specified:

`aperturecli --tls-cert .aperture/tls.cert info`

Through the CLI you can check the server’s `health`, get revenue statistics (`stats`), list and revoke L402 `tokens` and query past L402 `transactions`.

This interface can also be used to change pricing dynamically:

`aperturecli services update --name myapi --price 500`

## Model Context Protocol

Aperture also exposes an MCP interface for the use with agents. The interface supports the same commands as the CLI and accepts requests in JSON format.

To discover the structure and content of json commands accepted by Aperture, append `--dry-run` to the CLI commands above.

`aperturecli mcp serve`

## Rest API

Aperture exposes a Rest API at port `8081`. This API can be found at `/api/admin/<command>` and accepts all the commands from the CLI. Macaroon authentication is necessary using the admin.macaroon placed on startup in `~/.aperture` or the working directory of your choice.

## Dashboard

When the admin interface is enabled, Aperture also exposes a dashboard on port `8081`. This interface is only exposed to requests from `localhost`, but care needs to be taken when Aperture sits behind another proxy.
