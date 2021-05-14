# Configuration

[Install](../README.md#install) | [Usage](../README.md#usage) | [Features](./FEATURES.md) | [Requirements](./REQUIREMENTS.md) | [Configuration](./CONFIGURATION.md) | [Observability](./OBSERVABILITY.md)

## Navigation

Workbench renders navigation links using the [navigator](https://github.com/fremantle-industries/navigator)
package. It reads configured links for 1 or more OTP applications and generates
a list of navigation links.

Below is the list of routes that are available by default:

```elixir
config :navigator,
  links: %{
    workbench: [
      %{
        label: "Workbench",
        link: {WorkbenchWeb.Router.Helpers, :balance_all_path, [WorkbenchWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Balances",
        link: {WorkbenchWeb.Router.Helpers, :balance_day_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Wallets",
        link: {WorkbenchWeb.Router.Helpers, :wallet_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Accounts",
        link: {WorkbenchWeb.Router.Helpers, :account_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Orders",
        link: {WorkbenchWeb.Router.Helpers, :order_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Positions",
        link: {WorkbenchWeb.Router.Helpers, :position_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Products",
        link: {WorkbenchWeb.Router.Helpers, :product_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Fees",
        link: {WorkbenchWeb.Router.Helpers, :fee_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Venues",
        link: {WorkbenchWeb.Router.Helpers, :venue_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Advisors",
        link: {WorkbenchWeb.Router.Helpers, :advisor_path, [WorkbenchWeb.Endpoint, :index]}
      }
    ]
  }
```

If you would like to link to other Phoenix endpoints or external links consult the [navigator documentation](https://github.com/fremantle-industries/navigator#usage)

## Notifications

Workench provides a notification engine powered by [notified](https://github.com/fremantle-industries/notified).
You can create custom notifications and configure how they're handled by
referring to the [notified](https://github.com/fremantle-industries/notified#configuration) & [notified_phoenix](https://github.com/fremantle-industries/notified_phoenix#usage)
documentation.

```elixir
config :notified, pubsub_server: Workbench.PubSub
config :notified, receivers: []

config :notified_phoenix,
  to_list: {WorkbenchWeb.Router.Helpers, :notification_path, [WorkbenchWeb.Endpoint, :index]}
```

Workbench integrates with libcluster to send notifications when a node connects or disconnects from the cluster

```elixir
config :libcluster,
  topologies: [
    gossip: [
      strategy: Cluster.Strategy.Gossip,
      connect: {Workbench.Cluster.Nodes, :connect_node, []},
      disconnect: {Workbench.Cluster.Nodes, :disconnect_node, []},
      list_nodes: {Workbench.Cluster.Nodes, :nodes, [:connected]}
    ]
  ]
```
