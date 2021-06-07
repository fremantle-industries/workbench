defmodule WorkbenchWeb.PositionLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_node(params)
      |> assign_positions()

    {:noreply, socket}
  end

  def handle_info({:node_selected, _selected_node}, socket) do
    socket =
      socket
      |> assign_positions()
      |> push_patch(to: Routes.position_path(socket, :index))

    {:noreply, socket}
  end

  defp assign_positions(socket) do
    socket
    |> assign(:positions, sorted_positions(socket.assigns.node))
  end

  @order ~w[venue_id symbol credential_id]a
  defp sorted_positions(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.positions()
    |> Enumerati.order(@order)
  end
end
