defmodule WorkbenchWeb.PositionLive.Index do
  use WorkbenchWeb, :live_view
  alias WorkbenchWeb.Router.Helpers, as: Routes

  def mount(params, _session, socket) do
    sorted_node = params |> Map.get("node", Atom.to_string(node()))

    socket =
      socket
      |> assign(:node, sorted_node)
      |> assign(:positions, sorted_positions(sorted_node))

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    sorted_node = params |> Map.get("node", Atom.to_string(node()))
    params = %{node: sorted_node}

    socket =
      socket
      |> assign(:node, sorted_node)
      |> assign(:positions, sorted_positions(sorted_node))
      |> push_patch(to: Routes.live_path(socket, WorkbenchWeb.PositionLive.Index, params))

    {:noreply, socket}
  end

  @order ~w[venue_id symbol credential_id]a
  defp sorted_positions(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.positions()
    |> Enumerati.order(@order)
  end
end
