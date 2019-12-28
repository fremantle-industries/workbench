defmodule BackOfficeWeb.LivePositionView do
  use Phoenix.LiveView

  def render(assigns) do
    BackOfficeWeb.PositionView.render("index.html", assigns)
  end

  def mount(_, socket) do
    assigns = %{positions: positions()}

    {:ok, assign(socket, assigns)}
  end

  @order ~w(venue_id symbol account_id)a
  defp positions, do: Tai.Trading.PositionStore.all() |> Enumerati.order(@order)
end
