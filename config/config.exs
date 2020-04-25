# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Ecto Repo
config :workbench,
  ecto_repos: [Workbench.Repo]

# Configures the endpoint
config :workbench, WorkbenchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vJP36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP",
  render_errors: [view: WorkbenchWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Workbench.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "TolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Support .leex LiveView templates
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Elixir Logger
config :logger,
  backends: [{LoggerFileBackendWithFormatters, :file_log}],
  utc_log: true

config :logger, :file_log, path: "./log/#{Mix.env()}.log"

if System.get_env("DEBUG") == "true" do
  config :logger, :file_log, level: :debug
else
  config :logger, :file_log, level: :info
end

# Google OAuth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: {System, :get_env, ["GOOGLE_CLIENT_ID"]},
  client_secret: {System, :get_env, ["GOOGLE_CLIENT_SECRET"]}

config :workbench, WorkbenchWeb.Guardian,
  issuer: "workbench",
  secret_key: {System, :get_env, ["GUARDIAN_SECRET_KEY"]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
