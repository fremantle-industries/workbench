import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
partition = System.get_env("MIX_TEST_PARTITION")
default_database_url = "postgres://postgres:postgres@localhost:5432/workbench_?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url
database_url = "#{String.replace(configured_database_url, "?", "test")}#{partition}"

config :workbench, Workbench.Repo,
  url: database_url,
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :workbench, WorkbenchWeb.Endpoint,
  http: [port: 4002],
  server: false

config :tai, advisor_groups: %{}

config :tai,
  venues: %{
    mock_venue_a: [
      enabled: true,
      adapter: Tai.VenueAdapters.Mock,
      products: "btc_usdt eth_btc ltc_btc"
    ],
    mock_venue_b: [
      enabled: true,
      adapter: Tai.VenueAdapters.Mock,
      products: "ethu19 ltcu19"
    ]
  }

config :workbench,
  balance_snapshot: %{
    enabled: true,
    btc_usd_venue: :mock_venue_a,
    btc_usd_symbol: :btc_usdt,
    usd_quote_venue: :mock_venue_a,
    usd_quote_asset: :usdt,
    quote_pairs: [
      mock_venue_a: :usdt
    ]
  }
