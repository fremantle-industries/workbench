# Workbench - From Idea to Execution
[![Build Status](https://github.com/fremantle-industries/workbench/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/workbench/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/workbench.svg?style=flat)](https://hex.pm/packages/workbench)

Manage your trading operation across a distributed cluster

[Install](#install) | [Usage](#usage) | [Features](./docs/FEATURES.md) | [Requirements](./docs/REQUIREMENTS.md) | [Configuration](./docs/CONFIGURATION.md) | [Observability](./docs/OBSERVABILITY.md)

## Project Goals

`workbench` strives to provide a first class development environment that brings the same 
productivity and performance benefits from the [Phoenix](https://www.phoenixframework.org/) 
& [Elixir](https://elixir-lang.org/) community to real time algorithmic and quant workflows.

## Install

Add `workbench` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [
    {:workbench, "~> 0.0.13"}
  ]
end
```

Generate migrations

```bash
$ mix workbench.gen.migration
```

Run migrations

```bash
$ mix ecto.migrate
```

## Features

### Stream Real Time Orders

![stream-real-time-orders](./docs/stream-realtime-orders.png)

### Remotely Control Trade Instances in a Cluster

![remote-control-trade](./docs/remote-control-trade.png)

### Live Portfolio Tracking & Historical Snapshots

[![live-balance-snapshots](./docs/live-balance-snapshots.png)](https://youtu.be/cklMhS0KD88)

### Track Cold Storage

![wallets](./docs/wallets.png)

### Explore Products within the Trading Universe

![products-index](./docs/products-index.png)
![products-show](./docs/products-show.png)

### Receive Notifications

[![notifications](./docs/notifications.png)](https://youtu.be/NJS0YTsKoiQ)

### Monitor Operations Across Your Cluster

![dashboard-beam-vm-health](./docs/grafana-dashboard-beam-vm-health.png)

![dashboard-tai-health](./docs/grafana-dashboard-tai-health.png)

![dashboard-balances](./docs/grafana-dashboard-balances.png)

## Usage

### Running workbench as a standalone endpoint

Add the workbench phoenix endpoint to your config

```elixir
config :workbench, WorkbenchWeb.Endpoint,
  http: [port: 4000],
  url: [host: "workbench.localhost", port: "4000"],
```

### Embedding workbench in your own Elixir project

There are two options for running `workbench` along side your existing Elixir projects

1. Plug & Phoenix provide the ability to host multiple endpoints
as servers on different ports

```elixir
# config/config.exs
# Phoenix endpoints
config :my_app, MyAppWeb.Endpoint,
  pubsub_server: MyApp.PubSub,
  http: [port: 4000],
  url: [host: "my-app.localhost", port: "4000"],
  live_view: [signing_salt: "aolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"],
  secret_key_base: "vKt36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  server: true

config :workbench, WorkbenchWeb.Endpoint,
  pubsub_server: Tai.PubSub,
  http: [port: 4001],
  url: [host: "workbench.localhost", port: "4001"],
  live_view: [signing_salt: "aolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"],
  secret_key_base: "xKt36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  server: true
```

2. Use a proxy to host multiple endpoints on the same port [https://github.com/jesseshieh/master_proxy](https://github.com/jesseshieh/master_proxy)

```elixir
# mix.exs
def deps do
  [{:master_proxy, "~> 0.1"}]
end
```

```elixir
# config/config.exs
# Phoenix endpoints
config :niex, MyAppWeb.Endpoint,
  pubsub_server: Tai.PubSub,
  live_view: [signing_salt: "aolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"],
  secret_key_base: "vKt36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  server: false,
  debug_errors: true,
  check_origin: false

config :workbench, WorkbenchWeb.Endpoint,
  pubsub_server: Tai.PubSub,
  live_view: [signing_salt: "polmUusQ6//zaa5GZHu7DG2V3YAgOoP/"],
  secret_key_base: "xKt36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  server: false,
  debug_errors: true,
  check_origin: false


# Master Proxy
config :master_proxy,
  # any Cowboy options are allowed
  http: [:inet6, port: 4000],
  # https: [:inet6, port: 4443],
  backends: [
    %{
      host: ~r/my-app.localhost/,
      phoenix_endpoint: MyAppWeb.Endpoint
    },
    %{
      host: ~r/workbench.localhost/,
      phoenix_endpoint: WorkbenchWeb.Endpoint
    }
  ]
```

## Development

You can run the app natively on the host

```bash
$ docker-compose up db
$ mix setup
$ mix phx.server
```

Or within `docker-compose`

```
$ docker-compose up
```

Wait a few seconds for the app to boot and you should be able to view the app at `http://workbench.localhost:4000`

## Test

```bash
$ docker-compose up db
$ mix test
```

Save this and re-open workbench in a private tab

## Help Wanted :)

If you think this `workbench` thing might be worthwhile and you don't see a feature 
we would love your contributions to add them! Feel free to drop us an email or open 
a Github issue.

## Authors

* [Alex Kwiatkowski](https://github.com/rupurt) - alex+git@fremantle.io

## License

`workbench` is released under the [MIT license](./LICENSE.md)
