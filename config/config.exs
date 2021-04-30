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
  url: [host: "workbench.localhost"],
  secret_key_base: "vJP36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  render_errors: [view: WorkbenchWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Workbench.PubSub,
  live_view: [signing_salt: "TolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"]

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
        link: {WorkbenchWeb.Router.Helpers, :balance_all_path, [WorkbenchWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Balances",
        link: {WorkbenchWeb.Router.Helpers, :balance_day_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Accounts",
        link: {WorkbenchWeb.Router.Helpers, :account_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Wallets",
        link: {WorkbenchWeb.Router.Helpers, :wallet_path, [WorkbenchWeb.Endpoint, :index]}
      },
      %{
        label: "Orders",
        link:
          {WorkbenchWeb.Router.Helpers, :live_path,
           [WorkbenchWeb.Endpoint, WorkbenchWeb.OrderLive.Index]}
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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
