defmodule BackOfficeWeb.WalletController do
  use BackOfficeWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, BackOfficeWeb.LiveWalletView)
  end
end
