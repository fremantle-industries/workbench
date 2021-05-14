defmodule WorkbenchWeb.OrderLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:orders, sorted_orders(socket_with_node.assigns.node))

    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:orders, sorted_orders(socket_with_node.assigns.node))
      |> push_patch(to: Routes.order_path(socket, :index, %{node: socket_with_node.assigns.node}))

    {:noreply, socket}
  end

  @order ~w[group_id advisor_id]a
  defp sorted_orders(node) do
    [node: String.to_atom(node)]
    |> Tai.Commander.orders()
    |> Enumerati.order(@order)
  end
end
