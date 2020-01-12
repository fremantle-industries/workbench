defmodule BackOfficeWeb.FeeController do
  use BackOfficeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", fees: fees())
  end

  @order ~w(venue_id symbol credential_id)a
  defp fees, do: Tai.Venues.FeeStore.all() |> Enumerati.order(@order)
end
