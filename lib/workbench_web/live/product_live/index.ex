defmodule WorkbenchWeb.ProductLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]
  import WorkbenchWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:query, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_node(params)
      |> assign_products()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_products()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:node_selected, _selected_node}, socket) do
    socket =
      socket
      |> assign_products()
      |> push_patch(to: Routes.product_path(socket, :index))

    {:noreply, socket}
  end

  defp assign_products(socket) do
    query = socket.assigns.query

    products =
      sorted_products(socket.assigns.node)
      |> Enum.filter(fn p ->
        if query != nil do
          venue_id = p.venue_id |> Atom.to_string()
          symbol = p.symbol |> Atom.to_string()
          venue_symbol = p.venue_symbol
          type = p.type |> Atom.to_string()
          status = p.status |> Atom.to_string()

          [venue_id, symbol, venue_symbol, type, status]
          |> Enum.any?(&String.contains?(&1, query))
        else
          true
        end
      end)

    socket
    |> assign(:products, products)
  end

  @order [:venue_id, :symbol, :credential_id]
  defp sorted_products(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.products()
    |> Enumerati.order(@order)
  end
end
