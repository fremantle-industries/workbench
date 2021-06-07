defmodule Workbench.SelectedNode do
  use Agent

  @default_id :default

  def start_link(opts) do
    id = Keyword.get(opts, :id, @default_id)
    name = process_name(id)
    Agent.start_link(fn -> Workbench.Nodes.this() end, name: name)
  end

  def process_name(id), do: :"#{__MODULE__}_#{id}"

  def get(id \\ @default_id) do
    id
    |> process_name()
    |> Agent.get(& &1)
  end

  def put(node, id \\ @default_id) do
    id
    |> process_name()
    |> Agent.update(fn _ -> node end)
  end
end
