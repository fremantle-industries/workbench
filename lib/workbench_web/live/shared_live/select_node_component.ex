defmodule WorkbenchWeb.SharedLive.SelectNodeComponent do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Tag
  import WorkbenchWeb.ViewHelpers.NodeHelper, only: [assign_node: 2]

  def render(assigns) do
    nodes = Workbench.Nodes.nodes()
    selected_node = Workbench.SelectedNode.get()
    class = assigns[:class]

    ~L"""
    <form phx-change="node_selected" phx-target="<%= @myself %>" class="<%= class %>">
      <select name="node" id="select_nodes" phx-update="ignore">
        <%= for n <- nodes do %>
          <%= content_tag :option, value: n, selected: n == selected_node do %>
            <%= n %>
          <% end %>
        <% end %>
      </select>
    </form>
    """
  end

  def handle_event("node_selected", params, socket) do
    socket = assign_node(socket, params)
    send(self(), {:node_selected, socket.assigns.node})
    {:noreply, socket}
  end
end
