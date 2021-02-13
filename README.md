# Workbench - From Idea to Execution
[![Build Status](https://github.com/fremantle-industries/workbench/workflows/test/badge.svg)](https://github.com/fremantle-industries/workbench/actions?query=workflow%3Atest)

Manage your trading operation across a globally distributed cluster

## Project Goals

`workbench` strives to provide a first class development environment that brings the same 
productivity and performance benefits from the [Phoenix](https://www.phoenixframework.org/) 
& [Elixir](https://elixir-lang.org/) community to real time algorithmic and quant workflows.

## Features

### Remotely Control Trade Instances in the Cloud

![remote-control-trade](./docs/remote-control-trade.png)

### Live Portfolio Tracking & Historical Snapshots

[![live-balance-snapshots](./docs/live-balance-snapshots.png)](https://youtu.be/cklMhS0KD88)

### Watch System, Research & Trade Metrics Across Your Cluster

![metrics](./docs/metrics.png)

### Track Cold Storage

![wallets](./docs/wallets.png)

### Explore Products within the Trading Universe

![products-index](./docs/products-index.png)
![products-show](./docs/products-show.png)

## Planned Features

- Notifications
- Backtester
- Trade Execution Reports

## Requirements

- [Erlang OTP](https://www.erlang.org/)
- [Elixir](https://elixir-lang.org/)
- [Phoenix](https://www.phoenixframework.org/)
- [Tai](https://github.com/fremantle-industries/tai)
- [Postgres](https://www.postgresql.org/)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/OAuth2)

## Install

Add `workbench` to your list of dependencies in `mix.exs`

```elixir
def deps do
  [{:workbench, "~> 0.0.3"}]
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

Wait a few seconds for the app to boot and you should be able to view the app at `http://workbench.lvh.me:4000`

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
