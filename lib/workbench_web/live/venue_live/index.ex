defmodule WorkbenchWeb.VenueLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_node(params)
      |> assign_venues()

    {:noreply, socket}
  end

  @impl true
  def handle_event("start", %{"id" => id}, socket) do
    id
    |> String.to_atom()
    |> Tai.Commander.start_venue(node: String.to_atom(socket.assigns.node))

    socket =
      socket
      |> assign_venues()

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop", %{"id" => id}, socket) do
    id
    |> String.to_atom()
    |> Tai.Commander.stop_venue(node: String.to_atom(socket.assigns.node))

    socket =
      socket
      |> assign_venues()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:node_selected, _selected_node}, socket) do
    socket =
      socket
      |> assign_venues()
      |> push_patch(to: Routes.venue_path(socket, :index))

    {:noreply, socket}
  end

  defp assign_venues(socket) do
    socket
    |> assign(:venues, sorted_venues(socket.assigns.node))
  end

  @order [:id]
  defp sorted_venues(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.venues()
    |> Enumerati.order(@order)
  end
end
