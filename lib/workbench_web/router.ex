defmodule WorkbenchWeb.Router do
  use WorkbenchWeb, :router

  pipeline :auth do
    plug WorkbenchWeb.AuthAccessPipeline
  end

  pipeline :no_auth do
    plug WorkbenchWeb.NoAuthAccessPipeline
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", WorkbenchWeb do
    pipe_through [:browser, :no_auth]

    resources "/login", LoginController, only: [:index]

    get "/", Redirector, to: "/login"
  end

  scope "/", WorkbenchWeb do
    pipe_through [:browser, :auth]

    live "/balances", LiveBalanceView
    live "/accounts", LiveAccountView
    resources "/wallets", WalletController, only: [:index]
    live "/positions", LivePositionView
    resources "/products", ProductController, only: [:index, :show]
    resources "/fees", FeeController, only: [:index]
  end

  scope "/auth", WorkbenchWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    post "/logout", AuthController, :delete
  end
end
