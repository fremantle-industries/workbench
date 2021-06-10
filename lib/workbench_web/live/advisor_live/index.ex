defmodule WorkbenchWeb.AdvisorLive.Index do
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
      |> assign_search_query(params)
      |> assign_groups()
      |> assign_instances()

    {:noreply, socket}
  end

  @impl true
  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign_groups()
      |> assign_instances()
      |> push_patch(
        to: Routes.advisor_path(socket, :index, %{node: socket_with_node.assigns.node})
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_groups()
      |> assign_instances()

    {:noreply, socket}
  end

  @impl true
  def handle_event("start-group", %{"id" => group_id}, socket) do
    Tai.Commander.start_advisors(
      where: [group_id: String.to_atom(group_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign_groups()
      |> assign_instances()

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop-group", %{"id" => group_id}, socket) do
    Tai.Commander.stop_advisors(
      where: [group_id: String.to_atom(group_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign_groups()
      |> assign_instances()

    {:noreply, socket}
  end

  @impl true
  def handle_event("start-advisor", %{"group-id" => group_id, "advisor-id" => advisor_id}, socket) do
    Tai.Commander.start_advisors(
      where: [group_id: String.to_atom(group_id), advisor_id: String.to_atom(advisor_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign_groups()
      |> assign_instances()

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop-advisor", %{"group-id" => group_id, "advisor-id" => advisor_id}, socket) do
    Tai.Commander.stop_advisors(
      where: [group_id: String.to_atom(group_id), advisor_id: String.to_atom(advisor_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign_groups()
      |> assign_instances()

    {:noreply, socket}
  end

  defp assign_groups(socket) do
    query = socket.assigns.query

    groups =
      sorted_groups(socket.assigns.node)
      |> Enum.filter(fn g ->
        if query != nil do
          group_id = g.id |> Atom.to_string()
          String.contains?(group_id, query)
        else
          true
        end
      end)

    socket
    |> assign(:groups, groups)
  end

  defp assign_instances(socket) do
    query = socket.assigns.query

    instances =
      sorted_instances(socket.assigns.node)
      |> Enum.filter(fn i ->
        if query != nil do
          group_id = i.group_id |> Atom.to_string()
          advisor_id = i.advisor_id |> Atom.to_string()
          String.contains?(group_id, query) || String.contains?(advisor_id, query)
        else
          true
        end
      end)

    socket
    |> assign(:instances, instances)
  end

  @order [:group_id, :advisor_id]
  defp sorted_instances(node) do
    [node: String.to_atom(node)]
    |> Tai.Commander.advisors()
    |> Enumerati.order(@order)
  end

  defmodule Group do
    defstruct ~w(id total running stopped)a
  end

  @group_order [:id]
  def sorted_groups(node) do
    node
    |> sorted_instances
    |> Enum.reduce(
      %{},
      fn i, acc ->
        group = Map.get(acc, i.group_id, %Group{id: i.group_id, total: 0, running: 0, stopped: 0})

        group =
          i.status
          |> case do
            :running -> Map.put(group, :running, group.running + 1)
            _ -> Map.put(group, :stopped, group.stopped + 1)
          end
          |> Map.put(:total, group.total + 1)

        Map.put(acc, group.id, group)
      end
    )
    |> Map.values()
    |> Enumerati.order(@group_order)
  end

  defp format(nil), do: "-"
  defp format(val) when is_pid(val), do: val |> inspect()
  defp format(val), do: val
end
