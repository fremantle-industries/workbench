defmodule BackOfficeWeb.AuthController do
  use BackOfficeWeb, :controller
  plug Ueberauth

  alias BackOfficeWeb.UserFromAuth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> Guardian.Plug.sign_in(BackOfficeWeb.Guardian, user)
        |> redirect(to: "/balances")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> Guardian.Plug.sign_out(BackOfficeWeb.Guardian, [])
    |> redirect(to: "/")
  end
end
