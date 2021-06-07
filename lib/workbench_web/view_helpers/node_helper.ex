defmodule WorkbenchWeb.ViewHelpers.NodeHelper do
  def assign_node(conn, params) when is_map(params) do
    case Map.get(params, "node") do
      "" ->
        conn
        |> Phoenix.LiveView.assign(:node, Workbench.SelectedNode.get())

      nil ->
        conn
        |> Phoenix.LiveView.assign(:node, Workbench.SelectedNode.get())

      selected ->
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
end
