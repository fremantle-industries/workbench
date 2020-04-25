defmodule WorkbenchWeb.WalletController do
  use WorkbenchWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, WorkbenchWeb.LiveWalletView)
  end
end
