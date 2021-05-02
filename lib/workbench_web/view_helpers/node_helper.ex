defmodule WorkbenchWeb.ViewHelpers.NodeHelper do
  def selected_node(params) do
    Map.get(params, "node") || Workbench.SelectedNode.get() || Workbench.Nodes.this()
  end

  # def assign_node(conn, selected_node) when is_bitstring(selected_node) do
  #   assign_node(conn, %{"node" => selected_node})
  # end

  def assign_node(conn, params) when is_map(params) do
    selected = selected_node(params)

    if Workbench.Nodes.connected?(selected) do
      Workbench.SelectedNode.put(selected)

      conn
      |> Phoenix.LiveView.assign(:node, selected)
    else
      this_node = Workbench.Nodes.this()
      Workbench.SelectedNode.put(this_node)

      conn
      |> Phoenix.LiveView.put_flash(
        :warn,
        "Node '#{selected}' is not connected. Using current node '#{this_node}'"
      )
      |> Phoenix.LiveView.assign(:node, this_node)
    end
  end
end
