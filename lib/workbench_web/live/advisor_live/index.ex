defmodule WorkbenchWeb.AdvisorLive.Index do
  use WorkbenchWeb, :live_view
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:groups, sorted_groups(socket_with_node.assigns.node))
      |> assign(:instances, sorted_instances(socket_with_node.assigns.node))

    {:noreply, socket}
  end

  def handle_event("node_selected", params, socket) do
    socket_with_node = assign_node(socket, params)

    socket =
      socket_with_node
      |> assign(:groups, sorted_groups(socket_with_node.assigns.node))
      |> assign(:instances, sorted_instances(socket_with_node.assigns.node))
      |> push_patch(
        to: Routes.advisor_path(socket, :index, %{node: socket_with_node.assigns.node})
      )

    {:noreply, socket}
  end

  def handle_event("start-group", %{"id" => group_id}, socket) do
    Tai.Commander.start_advisors(
      where: [group_id: String.to_atom(group_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign(:groups, sorted_groups(socket.assigns.node))
      |> assign(:instances, sorted_instances(socket.assigns.node))

    {:noreply, socket}
  end

  def handle_event("stop-group", %{"id" => group_id}, socket) do
    Tai.Commander.stop_advisors(
      where: [group_id: String.to_atom(group_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign(:groups, sorted_groups(socket.assigns.node))
      |> assign(:instances, sorted_instances(socket.assigns.node))

    {:noreply, socket}
  end

  def handle_event("start-advisor", %{"group-id" => group_id, "advisor-id" => advisor_id}, socket) do
    Tai.Commander.start_advisors(
      where: [group_id: String.to_atom(group_id), advisor_id: String.to_atom(advisor_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign(:groups, sorted_groups(socket.assigns.node))
      |> assign(:instances, sorted_instances(socket.assigns.node))

    {:noreply, socket}
  end

  def handle_event("stop-advisor", %{"group-id" => group_id, "advisor-id" => advisor_id}, socket) do
    Tai.Commander.stop_advisors(
      where: [group_id: String.to_atom(group_id), advisor_id: String.to_atom(advisor_id)],
      node: String.to_atom(socket.assigns.node)
    )

    socket =
      socket
      |> assign(:groups, sorted_groups(socket.assigns.node))
      |> assign(:instances, sorted_instances(socket.assigns.node))

    {:noreply, socket}
  end

  def format(nil), do: "-"
  def format(val) when is_pid(val), do: val |> inspect()
  def format(val), do: val

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
end
