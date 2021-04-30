defmodule WorkbenchWeb.AccountLive.Index do
  use WorkbenchWeb, :live_view

  @default_show_zero false
  def mount(params, _session, socket) do
    Tai.SystemBus.subscribe(:account_store)
    sorted_node = params |> Map.get("node", Atom.to_string(node()))

    socket =
      socket
      |> assign(:node, sorted_node)
      |> assign(:accounts, accounts(sorted_node, show_zero: @default_show_zero))
      |> assign(:show_zero, @default_show_zero)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    show_zero = Map.get(params, "show_zero", "false") == "true"

    socket =
      socket
      |> assign(show_zero: show_zero)
      |> assign(:accounts, accounts(socket.assigns.node, show_zero: show_zero))

    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    sorted_node = params |> Map.get("node", Atom.to_string(node()))
    params = %{node: sorted_node}

    socket =
      socket
      |> assign(:node, sorted_node)
      |> assign(:accounts, accounts(sorted_node, show_zero: socket.assigns.show_zero))
      |> push_patch(to: Routes.account_path(socket, :index, params))

    {:noreply, socket}
  end

  def handle_info({:account_store, :after_put, _account}, socket) do
    socket =
      socket
      |> assign(:accounts, accounts(socket.assigns.node, show_zero: socket.assigns.show_zero))

    {:noreply, socket}
  end

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
