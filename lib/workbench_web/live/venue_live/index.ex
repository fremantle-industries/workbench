defmodule WorkbenchWeb.VenueLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:venues, sorted_venues(socket_with_node.assigns.node))

    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:venues, sorted_venues(socket.assigns.node))
      |> push_patch(to: Routes.venue_path(socket, :index, %{node: socket_with_node.assigns.node}))

    {:noreply, socket}
  end

  def handle_event("start", %{"id" => id}, socket) do
    id
    |> String.to_atom()
    |> Tai.Commander.start_venue(node: String.to_atom(socket.assigns.node))

    socket =
      socket
      |> assign(:venues, sorted_venues(socket.assigns.node))

    {:noreply, socket}
  end

  def handle_event("stop", %{"id" => id}, socket) do
    id
    |> String.to_atom()
    |> Tai.Commander.stop_venue(node: String.to_atom(socket.assigns.node))

    socket =
      socket
      |> assign(:venues, sorted_venues(socket.assigns.node))

    {:noreply, socket}
  end

  @order [:id]
  defp sorted_venues(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.venues()
    |> Enumerati.order(@order)
  end
end
