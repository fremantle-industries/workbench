defmodule BackOfficeWeb.LoginController do
  use BackOfficeWeb, :controller

  plug :put_layout, "unauthenticated.html"

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      conn
      |> redirect(to: "/balances")
    else
      conn
      |> render("index.html", current_user: current_user)
    end
  end
end
