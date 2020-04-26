defmodule WorkbenchWeb.PositionLive.Index do
  use WorkbenchWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:positions, sorted_positions())

    {:ok, socket}
  end

  @order ~w[venue_id symbol credential_id]a
  defp sorted_positions do
    Tai.Trading.PositionStore.all()
    |> Enumerati.order(@order)
  end
end
