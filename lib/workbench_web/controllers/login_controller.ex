defmodule WorkbenchWeb.LoginController do
  use WorkbenchWeb, :controller

  def index(conn, _params) do
    if Guardian.Plug.current_resource(conn) do
      redirect(conn, to: "/balances/all")
    else
      render(conn, "index.html")
    end
  end
end
