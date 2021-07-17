defmodule WorkbenchWeb.OrderTransitionLive.Index do
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
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_search()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:node_selected, _selected_node}, socket) do
    socket =
      socket
      |> assign_search()
      |> push_patch(
        to:
          Routes.order_transition_path(
            socket,
            :index,
            socket.assigns.client_id,
            %{query: socket.assigns.query}
          )
      )

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
    search_node = String.to_atom(socket.assigns.node)

    socket
    |> assign(
      :order,
      Tai.Commander.get_order_by_client_id(socket.assigns.client_id, node: search_node)
    )
  end

  defp assign_search(socket) do
    client_id = socket.assigns.client_id
    query = socket.assigns.query
    search_node = String.to_atom(socket.assigns.node)
    count = Tai.Commander.order_transitions_count(client_id, query, node: search_node)
    last_page = max(ceil(count / socket.assigns.page_size), 1)
    first_page = 1
    current_page = socket.assigns.current_page
    previous_page = max(current_page - 1, first_page)
    next_page = min(current_page + 1, last_page)

    order_transitions =
      Tai.Commander.order_transitions(
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
    |> assign(:order_transitions, order_transitions)
  end
end
