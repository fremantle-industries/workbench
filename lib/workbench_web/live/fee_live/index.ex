defmodule WorkbenchWeb.FeeLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_node(params)
      |> assign_fees()

    {:noreply, socket}
  end

  def handle_info({:node_selected, _selected_node}, socket) do
    socket =
      socket
      |> assign_fees()
      |> push_patch(to: Routes.fee_path(socket, :index))

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

  defp assign_fees(socket) do
    socket
    |> assign(:fees, sorted_fees(socket.assigns.node))
  end

  @order ~w[venue_id symbol credential_id]a
  defp sorted_fees(node_param) do
    [node: String.to_atom(node_param)]
    |> Tai.Commander.fees()
    |> Enumerati.order(@order)
  end
end
