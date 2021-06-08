import Config

# Shared variables
env = config_env() |> Atom.to_string()
http_port = (System.get_env("HTTP_PORT") || "4000") |> String.to_integer()
host = System.get_env("HOST") || "workbench.localhost"
secret_key_base = System.get_env("SECRET_KEY_BASE") || "vJP36v4Gi2Orw8b8iBRg6ZFdzXKLvcRYkk1AaMLYX0+ry7k5XaJXd/LY/itmoxPP"
live_view_signing_salt = System.get_env("LIVE_VIEW_SIGNING_SALT") || "TolmUusQ6//zaa5GZHu7DG2V3YAgOoP/"

# Telemetry
config :telemetry_poller, :default, period: 1_000

# Workbench
partition = System.get_env("MIX_TEST_PARTITION")
default_database_url = "postgres://postgres:postgres@localhost:5432/workbench_?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url
database_url = "#{String.replace(configured_database_url, "?", env)}#{partition}"

config :workbench, Workbench.Repo,
  url: database_url,
  pool_size: 5

config :workbench, WorkbenchWeb.Endpoint,
  http: [port: http_port],
  url: [host: host, port: http_port],
  render_errors: [view: WorkbenchWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Workbench.PubSub,
  secret_key_base: secret_key_base,
  live_view: [signing_salt: live_view_signing_salt]

config :workbench,
  asset_aliases: %{
    btc: [:xbt],
    usd: [:busd, :pax, :usdc, :usdt, :tusd]
  },
  balance_snapshot: %{
    enabled: {:system, :boolean, "BALANCE_SNAPSHOT_ENABLED", false},
    boot_delay_ms: {:system, :integer, "BALANCE_SNAPSHOT_BOOT_DELAY_MS", 10_000},
    every_ms: {:system, :integer, "BALANCE_SNAPSHOT_EVERY_MS", 60_000},
    btc_usd_venue: {:system, :atom, "BALANCE_SNAPSHOT_BTC_USD_VENUE", :binance},
    btc_usd_symbol: {:system, :atom, "BALANCE_SNAPSHOT_BTC_USD_SYMBOL", :btc_usdc},
    usd_quote_venue: {:system, :atom, "BALANCE_SNAPSHOT_USD_QUOTE_VENUE", :binance},
    usd_quote_asset: {:system, :atom, "BALANCE_SNAPSHOT_USD_QUOTE_ASSET", :usdt},
    quote_pairs: [binance: :usdt, okex: :usdt]
  }

# Support .leex LiveView templates
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

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

# Notifications
config :notified, pubsub_server: Workbench.PubSub

config :notified,
  receivers: [
    {NotifiedPhoenix.Receivers.Speech, []},
    {NotifiedPhoenix.Receivers.BrowserNotification, []}
  ]

config :notified_phoenix,
  to_list: {WorkbenchWeb.Router.Helpers, :notification_path, [WorkbenchWeb.Endpoint, :index]}

# Tai
config :tai, Tai.NewOrders.OrderRepo,
  url: database_url,
  pool_size: 5

config :tai, venues: %{}
config :tai, advisor_groups: %{}

# # Logger
# config :logger, :console,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id, :config_url]

# Conditional configuration
if config_env() == :dev do
  config :workbench, Workbench.Repo, show_sensitive_data_on_connection_error: true

  config :workbench, WorkbenchWeb.Endpoint,
    watchers: [
      npm: [
        "run",
        "watch",
        cd: Path.expand("../assets", __DIR__)
      ]
    ]

  config :workbench, WorkbenchWeb.Endpoint,
    live_reload: [
      patterns: [
        ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
        ~r"priv/gettext/.*(po)$",
        ~r"lib/workbench_web/{live,views}/.*(ex)$",
        ~r"lib/workbench_web/templates/.*(eex)$"
      ]
    ]

  config :workbench, WorkbenchWeb.Endpoint,
    debug_errors: true,
    check_origin: false

  config :tai, Tai.NewOrders.OrderRepo, show_sensitive_data_on_connection_error: true
end

if config_env() == :test do
  # Enable concurrent feature tests
  #
  # Your version of chromedriver must match the version of chrome to
  # successfully run feature tests.
  config :wallaby, otp_app: :workbench

  chromedriver_path =
    System.get_env("CHROMEDRIVER_BIN_PATH") ||
      raise """
      environment variable CHROMEDRIVER_BIN_PATH is missing.
      You must set it to the matching version of chrome to run feature tests.
      """

  config :wallaby, chromedriver: [path: chromedriver_path, headless: true]

  config :workbench, :sql_sandbox, true

  config :workbench, Workbench.Repo,
    pool: Ecto.Adapters.SQL.Sandbox,
    show_sensitive_data_on_connection_error: true

  config :tai, Tai.NewOrders.OrderRepo,
    pool: Ecto.Adapters.SQL.Sandbox,
    show_sensitive_data_on_connection_error: true

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
end
