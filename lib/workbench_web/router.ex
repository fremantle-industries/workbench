defmodule WorkbenchWeb.Router do
  use WorkbenchWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {WorkbenchWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", WorkbenchWeb do
    pipe_through([:browser])

    get("/", Redirector, to: "/balances/all")
    live("/balances/all", BalanceAllLive.Index, :index, as: :balance_all)
    live("/balances/day", BalanceDayLive.Index, :index, as: :balance_day)
    live("/balances/hour", BalanceHourLive.Index, :index, as: :balance_hour)
    live("/balances/table", BalanceTableLive.Index, :index, as: :balance_table)
    resources("/balances/config", BalanceConfigController)
    live("/accounts", AccountLive.Index, :index, as: :account)
    live("/wallets", WalletLive.Index, :index, as: :wallet)
    live("/positions", PositionLive.Index, :index, as: :position)
    live("/orders", OrderLive.Index)
    live("/products", ProductLive.Index, :index, as: :product)
    resources("/products/:venue", ProductController, only: [:show])
    live("/fees", FeeLive.Index, :index, as: :fee)
    live("/venues", VenueLive.Index, :index, as: :venue)
    live("/advisors", AdvisorLive.Index, :index, as: :advisor)
  end
end
