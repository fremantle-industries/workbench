defmodule WorkbenchWeb.FeeLive.Index do
  use WorkbenchWeb, :live_view
  alias WorkbenchWeb.Router.Helpers, as: Routes

  def mount(params, _session, socket) do
    selected_node = params |> Map.get("node", Atom.to_string(node()))

    socket =
      socket
      |> assign(:node, selected_node)
      |> assign(:fees, sorted_fees(selected_node))

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    selected_node = params |> Map.get("node", Atom.to_string(node()))
    params = %{node: selected_node}

    socket =
      socket
      |> assign(:node, selected_node)
      |> assign(:fees, sorted_fees(selected_node))
      |> push_patch(to: Routes.live_path(socket, WorkbenchWeb.FeeLive.Index, params))

    {:noreply, socket}
  end

  @attrs ~w(
    venue_id
    product_symbol
    credential_id
    maker
    maker_type
    taker
    taker_type
  )a
  def attrs, do: @attrs

  def pluck(attr, product), do: product |> Map.get(attr) |> format

  def format(nil), do: "-"
  def format(%Decimal{} = val), do: val |> decimal()
  def format(%DateTime{} = val), do: val |> relative_time()
  def format(val) when is_binary(val) or is_atom(val), do: val

  @order ~w[venue_id symbol credential_id]a
  defp sorted_fees(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.fees()
    |> Enumerati.order(@order)
  end
end
