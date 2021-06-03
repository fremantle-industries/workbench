import Config

# tai can't switch adapters at runtime
config :tai, order_repo_adapter: Ecto.Adapters.Postgres

# ecto_repos can't be detected in runtime.exs
config :workbench, ecto_repos: [Tai.NewOrders.OrderRepo, Workbench.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
