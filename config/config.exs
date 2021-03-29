# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Metrics
config :telemetry_poller, :default, period: 1_000

# Datastore
config :workbench, ecto_repos: [Workbench.Repo]

# Configures the endpoint
config :workbench, WorkbenchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJP36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  render_errors: [view: WorkbenchWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Workbench.PubSub,
  live_view: [signing_salt: "TolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"]

# Prometheus metrics server
prometheus_metrics_port =
  "PROMETHEUS_METRICS_PORT" |> System.get_env("9568") |> String.to_integer()

config :workbench, :prometheus_metrics_port, prometheus_metrics_port

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Support .leex LiveView templates
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :config_url]

# Navigation
config :navigator,
  links: %{
    workbench: [
      %{
        label: "Workbench",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.BalanceAllLive.Index]},
        class: "text-4xl"
      },
      %{
        label: "Balances",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.BalanceAllLive.Index]}
      },
      %{
        label: "Accounts",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.AccountLive.Index]}
      },
      %{
        label: "Wallets",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.WalletLive.Index]}
      },
      %{
        label: "Orders",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.OrderLive.Index]}
      },
      %{
        label: "Positions",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.PositionLive.Index]}
      },
      %{
        label: "Products",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.ProductLive.Index]}
      },
      %{
        label: "Fees",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.FeeLive.Index]}
      },
      %{
        label: "Venues",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.VenueLive.Index]}
      },
      %{
        label: "Advisors",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.AdvisorLive.Index]}
      }
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
