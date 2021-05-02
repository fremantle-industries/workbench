defmodule WorkbenchWeb.ProductLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:products, sorted_products(socket_with_node.assigns.node))

    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:products, sorted_products(socket.assigns.node))
      |> push_patch(
        to: Routes.product_path(socket, :index, %{node: socket_with_node.assigns.node})
      )

    {:noreply, socket}
  end

  @order [:venue_id, :symbol, :credential_id]
  defp sorted_products(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.products()
    |> Enumerati.order(@order)
  end
end
