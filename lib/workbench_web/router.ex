defmodule WorkbenchWeb.Router do
  use WorkbenchWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WorkbenchWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", WorkbenchWeb do
    pipe_through [:browser]

    get "/", Redirector, to: "/balances/all"
    live "/balances/all", BalanceAllLive.Index
    live "/balances/day", BalanceDayLive.Index
    live "/balances/hour", BalanceHourLive.Index
    live "/balances/table", BalanceTableLive.Index
    resources "/balances/config", BalanceConfigController
    live "/accounts", AccountLive.Index
    live "/wallets", WalletLive.Index
    live "/positions", PositionLive.Index
    live "/orders", OrderLive.Index
    live "/products", ProductLive.Index
    resources "/products/:venue", ProductController, only: [:show]
    live "/fees", FeeLive.Index
    live "/venues", VenueLive.Index
    live "/advisors", AdvisorLive.Index
  end

  scope "/" do
    pipe_through [:browser]

    live_dashboard("/metrics", metrics: WorkbenchWeb.Telemetry)
  end
end
