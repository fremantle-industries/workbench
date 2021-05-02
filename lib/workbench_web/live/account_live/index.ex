defmodule WorkbenchWeb.AccountLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  @impl true
  def mount(_params, _session, socket) do
    Tai.SystemBus.subscribe(:account_store)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    show_zero = Map.get(params, "show_zero", "false") == "true"
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(show_zero: show_zero)
      |> assign(:accounts, accounts(socket_with_node.assigns.node, show_zero: show_zero))

    {:noreply, socket}
  end

  @impl true
  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(
        :accounts,
        accounts(socket_with_node.assigns.node, show_zero: socket.assigns.show_zero)
      )
      |> push_patch(
        to: Routes.account_path(socket, :index, %{node: socket_with_node.assigns.node})
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:account_store, :after_put, _account}, socket) do
    socket =
      socket
      |> assign(:accounts, accounts(socket.assigns.node, show_zero: socket.assigns.show_zero))

    {:noreply, socket}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @order ~w(venue_id asset credential_id)a
  defp accounts(node_param, [show_zero: _] = filters) do
    node_param
    |> Workbench.Accounts.where(filters)
    |> Enumerati.order(@order)
  end
end
