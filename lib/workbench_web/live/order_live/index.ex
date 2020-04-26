defmodule WorkbenchWeb.OrderLive.Index do
  use WorkbenchWeb, :live_view
  alias WorkbenchWeb.Router.Helpers, as: Routes

  def mount(params, _session, socket) do
    selected_node = Map.get(params, "node", Atom.to_string(node()))

    socket =
      socket
      |> assign(:node, selected_node)
      |> assign(:orders, sorted_orders(selected_node))

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    selected_node = Map.get(params, "node", Atom.to_string(node()))
    params = %{node: selected_node}

    socket =
      socket
      |> assign(:node, selected_node)
      |> assign(:orders, sorted_orders(selected_node))
      |> push_patch(to: Routes.live_path(socket, WorkbenchWeb.OrderLive.Index, params))

    {:noreply, socket}
  end

  @order ~w[group_id advisor_id]a
  defp sorted_orders(node) do
    [node: String.to_atom(node)]
    |> Tai.Commander.orders()
    |> Enumerati.order(@order)
  end
end
