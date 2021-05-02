defmodule WorkbenchWeb.FailedOrderTransitionLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]
  import WorkbenchWeb.ViewHelpers.PaginationHelper, only: [assign_pagination: 2]
  import WorkbenchWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]

  @impl true
  def mount(%{"client_id" => client_id}, _session, socket) do
    Phoenix.PubSub.subscribe(Tai.PubSub, "order_updated:#{client_id}")

    socket =
      socket
      |> assign(:client_id, client_id)
      |> assign(:query, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_node(params)
      |> assign_order()
      |> assign_pagination(params)
      |> assign_search_query(params)
      |> assign_search()

    {:noreply, socket}
  end

  @impl true
  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign_search()
      |> push_patch(
        to:
          Routes.failed_order_transition_path(
            socket_with_node,
            :index,
            socket_with_node.assigns.client_id,
            %{
              node: socket_with_node.assigns.node,
              query: socket_with_node.assigns.query
            }
          )
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_search()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:order_updated, _client_id, _transition}, socket) do
    socket =
      socket
      |> assign_order()

    {:noreply, socket}
  end

  defp assign_order(socket) do
    selected_node = String.to_atom(socket.assigns.node)

    socket
    |> assign(
      :order,
      Tai.Commander.get_new_order_by_client_id(socket.assigns.client_id, node: selected_node)
    )
  end

  defp assign_search(socket) do
    client_id = socket.assigns.client_id
    query = socket.assigns.query
    search_node = String.to_atom(socket.assigns.node)
    count = Tai.Commander.failed_order_transitions_count(client_id, query, node: search_node)
    last_page = max(ceil(count / socket.assigns.page_size), 1)
    first_page = 1
    current_page = socket.assigns.current_page
    previous_page = max(current_page - 1, first_page)
    next_page = min(current_page + 1, last_page)

    failed_order_transitions =
      Tai.Commander.failed_order_transitions(
        client_id,
        query,
        page: current_page,
        page_size: socket.assigns.page_size,
        node: search_node
      )

    socket
    |> assign(:query, query)
    |> assign(:current_page, current_page)
    |> assign(:first_page, first_page)
    |> assign(:previous_page, previous_page)
    |> assign(:last_page, last_page)
    |> assign(:next_page, next_page)
    |> assign(:failed_order_transitions, failed_order_transitions)
  end
end
