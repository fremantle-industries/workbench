defmodule WorkbenchWeb.VenueLive.Index do
  use WorkbenchWeb, :live_view
  alias WorkbenchWeb.Router.Helpers, as: Routes

  def mount(params, _session, socket) do
    sorted_node = params |> Map.get("node", Atom.to_string(node()))

    socket =
      socket
      |> assign(:node, sorted_node)
      |> assign(:venues, sorted_venues(sorted_node))

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
      |> assign(:venues, sorted_venues(sorted_node))
      |> push_patch(to: Routes.venue_path(socket, :index, params))

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
