defmodule WorkbenchWeb.AuthErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:no_resource_found, :resource_not_found}, _opts) do
    conn |> Phoenix.Controller.redirect(to: "/auth/google")
  end

  def auth_error(conn, {:already_authenticated, _reason}, _opts) do
    conn |> Phoenix.Controller.redirect(to: "/balances/all")
  end

  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    conn |> Phoenix.Controller.redirect(to: "/")
  end

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end
