defmodule WorkbenchWeb.FleetLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]
  import WorkbenchWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]

  defmodule FleetRow do
    defstruct ~w[fleet_id total running stopped]a
  end

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
      |> assign_search_query(params)
      |> assign_fleets()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_fleets()

    {:noreply, socket}
  end

  @impl true
  def handle_event("start-fleet", %{"id" => fleet_id}, socket) do
    Tai.Commander.start_advisors(
      where: [fleet_id: String.to_atom(fleet_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign_fleets()

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop-fleet", %{"id" => fleet_id}, socket) do
    Tai.Commander.stop_advisors(
      where: [fleet_id: String.to_atom(fleet_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign_fleets()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:node_selected, _selected_node}, socket) do
    socket =
      socket
      |> assign_fleets()
      |> push_patch(to: Routes.fleet_path(socket, :index))

    {:noreply, socket}
  end

  defp assign_fleets(socket) do
    query = socket.assigns.query

    fleets =
      socket.assigns.node
      |> sorted_fleets()
      |> Enum.filter(fn f ->
        if query != nil do
          fleet_id = f.fleet_id |> Atom.to_string()
          String.contains?(fleet_id, query)
        else
          true
        end
      end)

    socket
    |> assign(:fleets, fleets)
  end

  @fleet_order [:fleet_id]
  def sorted_fleets(node) do
    node
    |> sorted_instances()
    |> Enum.reduce(
      %{},
      fn i, acc ->
        fleet = Map.get(acc, i.fleet_id, %FleetRow{fleet_id: i.fleet_id, total: 0, running: 0, stopped: 0})

        fleet =
          i.status
          |> case do
            :running -> Map.put(fleet, :running, fleet.running + 1)
            _ -> Map.put(fleet, :stopped, fleet.stopped + 1)
          end
          |> Map.put(:total, fleet.total + 1)

        Map.put(acc, fleet.fleet_id, fleet)
      end
    )
    |> Map.values()
    |> Enumerati.order(@fleet_order)
  end

  @order [:fleet_id, :advisor_id]
  defp sorted_instances(node) do
    [node: String.to_atom(node)]
    |> Tai.Commander.advisors()
    |> Enumerati.order(@order)
  end
end
